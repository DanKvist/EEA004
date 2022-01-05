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
        
uncertA = [ 0                           1   0                   0;
            0                           0   m*g/(J_R/R^2 + m)   0;
            0                           0   0                   1;
            m*g/(1.15*J + m*x_0(1)^2)   0   0                   0];
    
B = [   0;
        0;
        0;
        1/(J + m*x_0(1)^2)];
    
uncertB = [   0;
        0;
        0;
        1/(1.15*J + m*x_0(1)^2)];
    
C = [   1   0   0   0;
        0   0   1   0];

D = 0;

linSS = ss(A, B, C, D);
linTF = tf(linSS);
%% Calculate the zero input solution
t = 0:0.01:1;
x_0 = [0.2; 0.05; deg2rad(1); deg2rad(0.01)];
% x_0 = [0.2; 0.05; 1; 0.01];

y_cal = zeros(2, length(t));
for k = 1:length(t)
    y_cal(:, k) = C*expm(A*t(k))*x_0;
end


%% Simulate system with zero input

%input
u = zeros(size(t));

%simulate linear system
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
 
%Design parameters
p = [-7 -6 -3+3i -3-3i];

%Controller design
ppL = place(A, B, p);
ppL_r = pinv(C*inv(-A + B*ppL)*B);

%Linearized closed loop system
feedbackSys = ss(A-B*ppL, B*ppL_r, C, D);

%Simulate linear system
t = 0:0.01:5;
u = zeros(length(t),4);
% u(:,1) = 0.1;
x_0 = [0.4 0.2 deg2rad(1) deg2rad(0.3)];
% x_0 = [0.4 0.2 1 0.3];
y = lsim(feedbackSys, u, t, x_0);

figPoleLin = figure(4);
plot(t, y)
title({'Linearized Ball and Beam', 'pole placement control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figPoleLin, fullfile(figFolder, 'figPoleLin.png'))

%Simulate nonlinear system
L = ppL;
L_r = ppL_r;
load_system('feedbackControl')
outPole = sim('feedbackControl',5);

figPoleNon = figure(5);
plot(outPole.yout{1}.Values)
title({'Nonlinear Ball and Beam', 'pole placement control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figPoleNon, fullfile(figFolder, 'figPoleNon.png'))

%% Optimal control

%Design parameters
Q = [1      0       0       0;
     0      1       0       0;
     0      0       1       0;
     0      0       0       3];
R = 200;

%Controller design
lqrL = lqr(A, B, Q, R);
lqrL_r = pinv(C*inv(-A + B*lqrL)*B);

%Linearized closed loop system
feedbackSys = ss(A-B*lqrL, B*lqrL_r, C, D);

%Simulate linear system
t = 0:0.01:5;
u = zeros(length(t),4);
% u(:,1) = 0.1;
x_0 = [0.4 0.2 deg2rad(1) deg2rad(0.3)];
% x_0 = [0.4 0.2 1 0.3];
% x_0 = [0; 0; 0; 0];
y = lsim(feedbackSys, u, t, x_0);

figLqrLin = figure(6);
plot(t, y)
title({'Linearized Ball and Beam', 'LQR control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figLqrLin, fullfile(figFolder, 'figLqrLin.png'))

%Simulate nonlinear system
L = lqrL;
L_r = lqrL_r;
load_system('feedbackControl')
outLqr = sim('feedbackControl',5);

figLqrNon = figure(7);
plot(outLqr.yout{1}.Values)
title({'Nonlinear Ball and Beam', 'LQR control'})
xlabel('time [s]')
ylabel('states')
legend('r', 'd/dt{r}', '\theta', 'd/dt{\theta}')

saveas(figLqrNon, fullfile(figFolder, 'figLqrNon.png'))

%% Controller comparison

stepSize = 0.4;
settleThreshold = 0.05 * stepSize;

metric = [  "Error norm2";...
            "Error normInf";...
            "Control norm2";...
            "Control normInf";...
            "Overshoot";...
            "Settling time"];

%Pole placement
pPlace = norm(outPole.yout{3}.Values.Data);
pPlace = [pPlace; norm(outPole.yout{3}.Values.Data, inf)];
pPlace = [pPlace; norm(outPole.yout{2}.Values.Data)];
pPlace = [pPlace; norm(outPole.yout{2}.Values.Data, inf)];
pPlace = [pPlace; abs(min(outPole.yout{1}.Values.Data(:,1)) / stepSize)];

notSettled =    outPole.yout{1}.Values.Data(:,1) > settleThreshold |...
                outPole.yout{1}.Values.Data(:,1) < -settleThreshold;
pPlace = [pPlace; outPole.yout{1}.Values.Time(find(notSettled,1,'last'))];

%LQR design
lqrDes = norm(outLqr.yout{3}.Values.Data);
lqrDes = [lqrDes; norm(outLqr.yout{3}.Values.Data, inf)];
lqrDes = [lqrDes; norm(outLqr.yout{2}.Values.Data)];
lqrDes = [lqrDes; norm(outLqr.yout{2}.Values.Data, inf)];
lqrDes = [lqrDes; abs(min(outLqr.yout{1}.Values.Data(:,1)) / stepSize)];

notSettled =    outLqr.yout{1}.Values.Data(:,1) > settleThreshold |...
                outLqr.yout{1}.Values.Data(:,1) < -settleThreshold;
lqrDes = [lqrDes; outLqr.yout{1}.Values.Time(find(notSettled,1,'last'))];

table(metric, pPlace, lqrDes)

%% Uncertain plant model

%Build uncertain linear feedback systems
uncertPpSys = ss(uncertA - B*ppL, uncertB*ppL_r, C, D);
uncertLqrSys = ss(uncertA - B*lqrL, uncertB*lqrL_r, C, D);

%Simulate uncertain linear system
t = 0:0.01:5;
u = zeros(length(t),4);
x_0 = [0.4 0.2 deg2rad(1) deg2rad(0.3)];
% x_0 = [0.4 0.2 1 0.3];
ppY = lsim(uncertPpSys, u, t, x_0);
lqrY = lsim(uncertLqrSys, u, t, x_0);

%Uncertain beam inerita example
J = 1.15*J;

%Simulate uncertain nonlinear system
L = ppL;
L_r = ppL_r;
load_system('feedbackControl')
outPole = sim('feedbackControl',5);

L = lqrL;
L_r = lqrL_r;
outLqr = sim('feedbackControl',5);

figUncert = figure(8);
plot(t, [ppY(:,1) lqrY(:,1)])
hold on
plot(outPole.yout{1}.Values.Time, outPole.yout{1}.Values.Data(:,1))
plot(outLqr.yout{1}.Values.Time, outLqr.yout{1}.Values.Data(:,1))
hold off
title({'Uncertain Ball and Beam', 'ball position r when beam inertia is off by 15%'})
xlabel('time [s]')
ylabel('states')
legend('linear PP', 'linear LQR', 'Nonlin PP', 'Nonlin LQR')

saveas(figUncert, fullfile(figFolder, 'figUncert.png'))
