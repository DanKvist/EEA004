%-------------------------------------------------------------------------
%% Question 1 - Find the transfer function
% Specify parameters for the heater and humidifier assignment.
% Time constant is provided by the assignment.
% Gain is obtained form the Entropy-Enthalpy chart.
%-------------------------------------------------------------------------

tau1 = 50;
tau2 = 10;

K11 =  15;
K12 = -25;
K21 = -10;
K22 =  70;

G_u1y1 = tf( 15, [50 1]);
G_u1y2 = tf(-25, [50 1]);
G_u2y1 = tf(-10, [10 1]);
G_u2y2 = tf( 70, [10 1]);

G = [G_u1y1 G_u1y2; G_u2y1 G_u2y2]

