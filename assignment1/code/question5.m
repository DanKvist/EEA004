%-------------------------------------------------------------------------
%% Controller design
%-------------------------------------------------------------------------

%% First guess, unity gain controller
L_y = [1 0;0 1];
L_r = L_y;

G_cl = minreal((eye(size(G)) + G*L_y) \ (G*L_r));
S = (eye(size(G)) + G*L_y) \ eye(size(G));
T = minreal((eye(size(G)) + G*L_y) \ (G*L_y));
S_u = (eye(size(G)) + L_y*G) \ eye(size(G));

pzmap(G_cl)
hold on
pzmap(S)
pzmap(T)
pzmap(S_u)
hold off



plot(real(pole(G_cl)), imag(pole(G_cl)),'*')

legend('G_{cl}', 'S', 'T', 'S_u')

%% Second guess

desiredPoles = [-2 -2/4];
[Ky, prec] = place(G_ss.a, G_ss.b, desiredPoles)

G_sys = feedback(G_ss, Ky);

pzmap(G_sys)

%% Third guess



%% Closed loop, sensitivity, complementary, input sensitivity


