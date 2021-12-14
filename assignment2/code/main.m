%% Intorduction
% Configuration and prerequisites
clear all;
close all;
clc;

w_c = 1/10;

s = tf([1 0],1);

% Plant transfer function
G_11 = tf(15,[50 1]);
G_12 = tf(-11, [10 1]);
G_21 = tf(-25, [50 1]);
G_22 = tf(70, [10 1]);
G = [G_11 G_12;G_21 G_22];

%% Relative gain array

RGA = G .* (G\eye(2)).'

RGA_0 = evalfr(RGA, 0*1i)
RGA_wc = evalfr(RGA, w_c*1i)

%% Decoupling A

F_y = eye(2);
W2 = eye(2);

%Case 0

W1_0 = eye(2);
G_cl = feedback(W1_0*F_y*G, eye(2));

fig1=figure;
step(G_cl)

% Case i

W1_i = evalfr(G,0i)\eye(2);
G_cl = feedback(W1_i*F_y*G, F_y);

hold on
step(G_cl)
hold off

%Case ii

W1_ii = real(evalfr(G,1/10*1i))\eye(2);
G_cl = feedback(W1_ii*F_y*G, eye(2));

hold on
step(G_cl)
hold off

figFolder = "figures";
mkdir(figFolder)
saveas(fig1, fullfile(figFolder, 'decoupling_a.png'))

%% Decoupling B
fig2=figure;

F_y = tf([10 1], [10 0])*eye(2);

G_cl = feedback(W1_0*F_y*G, eye(2));
step(G_cl)
hold on
G_cl = feedback(W1_i*F_y*G, eye(2));
step(G_cl)
G_cl = feedback(W1_ii*F_y*G, eye(2));
step(G_cl)
hold off

figFolder = "figures";
mkdir(figFolder)
saveas(fig2, fullfile(figFolder, 'decoupling_b.png'))

%% LQG(R) control
fig3=figure;

Q_1 = 1*eye(2);
Q_2 = 1*eye(2);

G_ss = ss(G);
G_ss = ss2ss(G_ss, G_ss.C);

L = lqr(G_ss, Q_1, Q_2);

F_y = L

G_cl = feedback(G_ss, F_y);

step(G_cl)

figFolder = "figures";
mkdir(figFolder)
saveas(fig3, fullfile(figFolder, 'lqg.png'))
