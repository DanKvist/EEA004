%-------------------------------------------------------------------------
%% Question 5 - Controller design
%  Explore three different scenarios:
%  Scenario 1 - Unity gain controller
%  Scenario 2 - ??
%  Scenario 3 - ??
%-------------------------------------------------------------------------

%% Scenario 1 - unity gain controller
L_y = [1 0;0 1];
L_r = L_y;

G_cl = minreal((eye(size(G)) + G*L_y) \ (G*L_r));
S    = (eye(size(G)) + G*L_y) \ eye(size(G));
T    = minreal((eye(size(G)) + G*L_y) \ (G*L_y));
S_u  = (eye(size(G)) + L_y*G) \ eye(size(G));

fig3 = figure;
subplot(2,2,1)
opt = pzoptions;
opt.Title.String = "Pole-Zero Map of Closed Loop System";
pzplot(G_cl,opt)

subplot(2,2,2)
opt.Title.String = "Pole-Zero Map of S";
pzplot(S,opt)

subplot(2,2,3)
opt.Title.String = "Pole-Zero Map of T";
pzplot(T,opt)

subplot(2,2,4)
opt.Title.String = "Pole-Zero Map of S_u";
pzplot(S_u,opt)

saveas(fig3, fullfile(figFolder, 'PoleZeros.png'))

%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------

fig4 = figure;
subplot(2,2,1)
opt = sigmaoptions;
opt.Title.String = "Singular values of Closed Loop System";
sigmaplot(G_cl,opt)

subplot(2,2,2)
opt.Title.String = "Singular values of S";
sigmaplot(S,opt)

subplot(2,2,3)
opt.Title.String = "Singular values of T";
sigmaplot(T,opt)

subplot(2,2,4)
opt.Title.String = "Singular values of S_u";
sigmaplot(S_u,opt)

saveas(fig4, fullfile(figFolder, 'SingularValues.png'))


%figure
%plot(real(pole(G_cl)), imag(pole(G_cl)),'*')

%legend('G_{cl}', 'S', 'T', 'S_u')

%% Second guess

desiredPoles = [-2 -2/4];
[Ky, prec] = place(G_ss.a, G_ss.b, desiredPoles)

G_sys = feedback(G_ss, Ky);

%pzmap(G_sys)

%% Third guess



%% Closed loop, sensitivity, complementary, input sensitivity


