function result = isAC(filename)
%isAC function to check the audiofile
%   if the audio represent AC word, it will return true = 1
%   else it will return False = 0
M = [];
theta_matrix = [];
Y_matrix = [];
for N = 50:10:100
    Y = [];
    Sai = [];
    theta = [];
    s = 1000;
    for i = 1:10
        name = ['Z:\AC_train\AC_' num2str(i) '.m4a'];
        [y, Fs] = audioread(name);
        y = y(:,1);
        y = y/max(y);
        [CA, CD] = dwt(y,'db2');
        [CA, CD] = dwt(CA,'db2');
        [CA, CD] = dwt(CA,'db2');
        [CA, CD] = dwt(CA,'db2');
        for j = N+1:s
            Y = [Y; CA(j)];
            Sai = [Sai; [CA(j-1:-1:j-N)']];
        end
    end
    m = pinv(Sai);
    theta = pinv(Sai)*Y;
    theta_matrix = [theta_matrix; theta];
    Y_matrix = [Y_matrix; Y];
    Y_hat = Sai*theta;
    M = [M; mse(Y,Y_hat)];
end
N = 50:10:100;
disp('First: the best N is selected based on the Mean Square Error');
disp('As shown in the figure below');
figure, plot(N,M);
title('MSE Vs. N');
xlabel('N'); ylabel('MSE');
grid on; grid minor;
disp('Second: The best N is 100');
% Evaluate Y for the test audiofile
N = 100;
Sai_test = [];
[y, Fs] = audioread(filename);
y = y(:,1);
y = y/max(y);
[CA, CD] = dwt(y,'db2');
[CA, CD] = dwt(CA,'db2');
[CA, CD] = dwt(CA,'db2');
[CA, CD] = dwt(CA,'db2');
for j = N+1:s
    Sai_test = [Sai_test; CA(j-1:-1:j-N)'];
end
Y_hat = Sai_test*theta(N);
M = mse(Y(N),Y_hat);
disp(['The MSE of the audiofile selected at (N=100) = ' num2str(M)]);
if M <= 0.2
    result = 1;
else
    retult = 0;
end
end