%% Intorduction
% Build the plant transfer function

G_11 = tf(15,[50 1]);
G_12 = tf(-11, [10 1]);
G_21 = tf(-25, [50 1]);
G_22 = tf(70, [10 1]);

G = [G_11 G_12;G_21 G_22];

%% Relative gain array

w_c = 1/10;

RGA = G .* (G\eye(2)).'

RGA_0 = evalfr(RGA, 0*1i)
RGA_wc = evalfr(RGA, w_c*1i)

%% Decoupling A

F_y = eye(2);
W2 = eye(2);

%Case 0

W1_0 = eye(2);
G_cl = feedback(W1_0*F_y*G, eye(2));

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

%% Decoupling B

F_y = tf([10 1], [10 0])*eye(2);

G_cl = feedback(W1_0*F_y*G, eye(2));
step(G_cl)
hold on
G_cl = feedback(W1_i*F_y*G, eye(2));
step(G_cl)
G_cl = feedback(W1_ii*F_y*G, eye(2));
step(G_cl)
hold off


%% LQG(R) control

Q_1 = 1*eye(2);
Q_2 = 1*eye(2);

G_ss = ss(G);
G_ss = ss2ss(G_ss, G_ss.C);

L = lqr(G_ss, Q_1, Q_2);

F_y = L

G_cl = feedback(G_ss, F_y);

step(G_cl)

% [kest, K, ~] = kalman(G_ss, eye(2), eye(2));
% 
% A = G_ss.a;
% B = G_ss.b;
% C = G_ss.c;
% D = G_ss.d;
% 
% F_y = L*(s*eye(2) - A + B*L + K*C)\K;
% F_r = eye(2) - L*(s*eye(2) - A + B*L + K*C)\B;
% 
% G_cl = F_r*feedback(G, F_y);
% 
% step(G_cl)