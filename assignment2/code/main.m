%% Introduction
% Configuration and prerequisites
clear all;
close all;
clc;

%For saving figures
figFolder = "figures";
mkdir(figFolder)

%Design cross-over frequency
w_c = 1/10;

%Color palette
colors = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30"];

% Plant transfer function
G_11 = tf(15,[50 1]);
G_12 = tf(-11, [10 1]);
G_21 = tf(-25, [50 1]);
G_22 = tf(70, [10 1]);
G = [G_11 G_12;G_21 G_22];

%% Relative gain array

RGA = G .* (G\eye(2)).';

RGA_0 = evalfr(RGA, 0*1i)
RGA_wc = evalfr(RGA, w_c*1i)

%% Decoupling A

F_diag = eye(2);
W2 = eye(2);
G_inv = G\eye(2);

t = 0:200;
r = [ones(size(t))' zeros(size(t))'];


%Case 0
W1_0 = eye(2);
F_y_0 = W1_0*F_diag*W2;
G_cl_0 = feedback(G, F_y_0);

% Case i
W1_i = evalfr(G_inv,0i);
F_y_i = W1_i*F_diag*W2;
G_cl_i = feedback(G, F_y_i);

%Case ii
W1_ii = real(evalfr(G_inv,1i/10));
F_y_ii = W1_ii*F_diag*W2;
G_cl_ii = feedback(G, F_y_ii);


fig1=figure(1);

y = lsim(G_cl_0, r, t);
u = ([eye(2) -F_y_0]*[r';y'])';
dualPlot(y, u, colors(1))

y = lsim(G_cl_i, r, t);
u = ([eye(2) -F_y_i]*[r';y'])';
dualPlot(y, u, colors(2))

y = lsim(G_cl_ii, r, t);
u = ([eye(2) -F_y_ii]*[r';y'])';
dualPlot(y, u, colors(3))

saveas(fig1, fullfile(figFolder, 'decoupling_a.png'))

%% Decoupling B

F_y = tf([10 1], [10 0])*eye(2);

G_cl = feedback(F_y*G, W1_ii);

fig2=figure();

y = lsim(G_cl, r, t);
u = lsim(F_y, r - (W1_ii*y')', t);
dualPlot(y, u, colors(1))

saveas(fig2, fullfile(figFolder, 'decoupling_b.png'))

%% LQG(R) control


G_ss = ss(G);
G_ss = ss2ss(G_ss, G_ss.C);

Q_1 = eye(2);
Q_2 = eye(2);

%Case 0
L_0 = lqr(G_ss, Q_1, Q_2);
G_cl_0 = feedback(G_ss, L_0);

%Case i
L_i = lqr(G_ss, Q_1, 0.1*Q_2);
G_cl_i = feedback(G_ss, L_i);

%Case ii
L_ii = lqr(G_ss, Q_1, 10*Q_2);
G_cl_ii = feedback(G_ss, L_ii);

% step(G_cl)

fig3=figure(3);

y = lsim(G_cl_0, u, t);
u = ([eye(2) -L_0]*[r';y'])';
dualPlot(y, u, colors(1))

y = lsim(G_cl_i, u, t);
u = ([eye(2) -L_i]*[r';y'])';
dualPlot(y, u, colors(2))

y = lsim(G_cl_ii, u, t);
u = ([eye(2) -L_ii]*[r';y'])';
dualPlot(y, u, colors(3))

saveas(fig3, fullfile(figFolder, 'lqg.png'))

%% Utilities

function [] = dualPlot(y, u, color)
    
    subplot(2,1,1);
    plot(y(:,1), "Color", color, "LineStyle", "-")
    hold on
    plot(y(:,2), "Color", color, "LineStyle", "--")
    xlabel("Time (seconds)")
    ylabel("Amplitude")
    title('Step Response')
    xlim([0 length(y)])

    subplot(2,1,2); 
    plot(u(:,1), "Color", color, "LineStyle", "-")
    hold on
    plot(u(:,2), "Color", color, "LineStyle", "--")
    xlabel("Time (seconds)")
    ylabel("Amplitude")
    title('Step Response')
    xlim([0 length(y)])

end