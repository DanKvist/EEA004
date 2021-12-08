%% Design speed controller

%Design choice
w_n = 2.5;
zeta = 1.2;

K_i = w_n^2*0.66/0.87
K_p = (2*zeta*w_n*0.66 - 1)/0.87