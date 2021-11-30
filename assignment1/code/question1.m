%-------------------------------------------------------------------------
%% Question 1 - Find the transfer function
% Specify parameters for the heater and humidifier assignment.
% Time constant is provided by the assignment.
% Gain is obtained form the Entropy-Enthalpy chart.
%-------------------------------------------------------------------------

tau1 = 50;
tau2 = 10;

K_y1u1 =  15;
K_y1u2 = -11;
K_y2u1 = -25;
K_y2u2 =  70;

G_y1u1 = tf( K_y1u1, [tau1 1]);
G_y1u2 = tf( K_y1u2, [tau2 1]);
G_y2u1 = tf( K_y2u1, [tau1 1]);
G_y2u2 = tf( K_y2u2, [tau2 1]);

G = [G_y1u1 G_y1u2; G_y2u1 G_y2u2]

