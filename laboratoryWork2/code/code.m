%% Laboratory work 2
% Code for working with the ball and beam system

clear;
close all;

%System parameters
m = 0.11;
R = 0.015;
M = 1;
g = 9.8;
L = 1;
J_R = 1e-5;
J = 2e-3;

%Initial conditions
x_0 = [0; 0; 0; 0];

%Figure saving
figFolder = 'figures';
mkdir(figFolder)

%% Simulate step of nonlinear system

load_system('systemAnalysis')
set_param('systemAnalysis/Manual Switch', 'sw', '1')

out = sim('systemAnalysis',1);

bbStep = figure(1);
plot(out.yout{1}.Values)

title('Ball and Beam, step response')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(bbStep, fullfile(figFolder, 'bbStep.png'))

%% Simulate sine wave of nonlinear system

%Initial conditions
x_0 = [0; 0; -2.5e-4; 0];

load_system('systemAnalysis')
set_param('systemAnalysis/Manual Switch', 'sw', '0')

out = sim('systemAnalysis',3);

sineWave = figure(2);
plot(out.yout{1}.Values)

title('Ball and Beam, sine wave response')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(sineWave, fullfile(figFolder, 'sineWave.png'))

%% Build linearized system

x_0 = [0 0 0 0];

A = [   0                       1   0                   0;
        0                       0   m*g/(J_R/R^2 + m)   0;
        0                       0   0                   1;
        m*g/(J + m*x_0(1)^2)    0   0                   0];
        
B = [   0;
        0;
        0;
        1/(J + m*x_0(1)^2)];
    
C = [   1   0   0   0;
        0   0   1   0];

D = 0;

linSS = ss(A,B,C,D);
linTF = tf(linSS);

%% Calculate the zero input solution
t = 0:0.01:1;
x_0 = [0.2; 0.05; deg2rad(1); deg2rad(0.01)];

y_cal = zeros(2, length(t));
for k = 1:length(t)
    y_cal(:, k) = C*expm(A*t(k))*x_0;
end


%% Simulate system with zero input
u = zeros(size(t));

y_sim = lsim(linSS, u, t, x_0);

zeroIn = figure(3);
plot(t, y_cal' - y_sim)

title({'Linearized Ball and Beam', 'Difference between calculation and simulation'})
xlabel('Time [s]')
ylabel('States')
legend('r', '\theta')

saveas(zeroIn, fullfile(figFolder, 'zeroIn.png'))

%% Controllability

rank(ctrb(linSS))

%% Observability

disp('i')
disp(rank(obsv(linSS)))

C = [0 1 0 0;0 0 0 1];
disp('ii')
disp(rank(obsv(A,C)))

C = [1 0 0 0];
disp('iii')
disp(rank(obsv(A,C)))

C = [0 0 1 0];
disp('iv')
disp(rank(obsv(A,C)))

C = [1 0 0 0;0 0 0 1];
disp('v')
disp(rank(obsv(A,C)))

C = [0 1 0 0;0 0 1 0];
disp('vi')
disp(rank(obsv(A,C)))

%% Pole placement controller

%all states measurable
C = [1 0 0 0;
     0 1 0 0;
     0 0 1 0;
     0 0 0 1;];
 

p = [-7 -6 -3+3i -3-3i];
L = place(A, B, p);
L_r = pinv(C*inv(-A + B*L)*B);


feedbackSys = ss(A-B*L, B*L_r, C, D);

t = 0:0.01:5;
u = zeros(length(t),4);
% u(:,1) = 0.1;
x_0 = [0.4 0.2 deg2rad(1) deg2rad(0.3)];
y = lsim(feedbackSys, u, t, x_0);

figPoleLin = figure(4);
plot(t, y)
title({'Linearized Ball and Beam', 'pole placement control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figPoleLin, fullfile(figFolder, 'figPoleLin.png'))

load_system('feedbackControl')
outLin = sim('feedbackControl',5);

figPoleNon = figure(5);
plot(outLin.yout{1}.Values)
title({'Nonlinear Ball and Beam', 'pole placement control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figPoleNon, fullfile(figFolder, 'figPoleNon.png'))

%% Optimal control

Q = [30     0       0       0;
     0      1       0       0;
     0      0       1       0;
     0      0       0       1];
R = 1;

L = lqr(A, B, Q, R);
L_r = pinv(C*inv(-A + B*L)*B);

feedbackSys = ss(A-B*L, B*L_r, C, D);

t = 0:0.01:5;
u = zeros(length(t),4);
% u(:,1) = 0.1;
x_0 = [0.4 0.2 deg2rad(1) deg2rad(0.3)];
% x_0 = [0; 0; 0; 0];
y = lsim(feedbackSys, u, t, x_0);

figLqrLin = figure(6);
plot(t, y)
title({'Linearized Ball and Beam', 'LQR control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figLqrLin, fullfile(figFolder, 'figLqrLin.png'))

load_system('feedbackControl')
outNon = sim('feedbackControl',5);

figLqrNon = figure(7);
plot(outNon.yout{1}.Values)
title({'Nonlinear Ball and Beam', 'LQR control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figLqrNon, fullfile(figFolder, 'figLqrNon.png'))
