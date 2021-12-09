%% Setup and specification

%Design choice
w_n = 2.5;
zeta = 1.2;

s = tf([1 0],1);

%% Design speed controller

K_i = w_n^2*0.66/0.87
K_p = (2*zeta*w_n*0.66 - 1)/0.87

%% Design tension controller

secondOrd = w_n^2/(s^2 + 2*zeta*w_n*s + w_n^2)
myPoles = pole(secondOrd)

firstOrd = 1/(s - 10*real(min(myPoles)))

thirdOrd = firstOrd*secondOrd

K_d = (thirdOrd.Denominator{:}(2) - 8.05)/554
K_p = (thirdOrd.Denominator{:}(3) - 263)/554
K_i = (thirdOrd.Denominator{:}(4))/554