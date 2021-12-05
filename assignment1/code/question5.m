%--------------------------------------------------------
%% Question 5 - Controller design
%  Explore three different scenarios:
%  Scenario 1 - Unity gain controller
%  Scenario 2 - k1 = 1, k2 = 0.1
%  Scenario 3 - k1 = 1, k2 = 10
%--------------------------------------------------------

%% Scenario 1 - unity gain controller

%Define controller
L_y = [1 0;0 1];
L_r = L_y;

[G_cl, S, T, S_u] = getStabilityFunc(G, L_y, L_r);

pole(G_cl)

legendArray = [];
legendArray = [legendArray;
    strcat( "k_1 = ", ...
            num2str(L_y(1,1)), ...
            ", k_2 = ", ...
            num2str(L_y(2,2)))];


%Plot singular values
opt = sigmaoptions;
opt.Grid = 'on';
opt.YLimMode = 'manual';
opt.YLim = {[-40, 10]};

plotCL = figure;
opt.Title.String = "Singular values of G_c";
sigmaplot(G_cl,opt)

plotS = figure;
opt.Title.String = "Singular values of S";
sigmaplot(S,opt)

plotT = figure;
opt.Title.String = "Singular values of T";
sigmaplot(T,opt)

plotSu = figure;
opt.Title.String = "Singular values of S_u";
sigmaplot(S_u,opt)

%-------------------------------------------------
%Plot poles and zeros
poleZeroFigure = figure;
subplot(2,2,1)
opt = pzoptions;
opt.Title.String = "Pole-Zero Map of G_c";
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

%% Second guess

%Define controller
L_y = [1 0;0 0.1];
L_r = L_y;

[G_cl, S, T, S_u] = getStabilityFunc(G, L_y, L_r);

pole(G_cl)

legendArray = [legendArray;
    strcat( "k_1 = ", ...
            num2str(L_y(1,1)), ...
            ", k_2 = ", ...
            num2str(L_y(2,2)))];

%Plot singular values
figure(plotCL)
hold on
sigmaplot(G_cl)

figure(plotS)
hold on
sigmaplot(S)

figure(plotT)
hold on
sigmaplot(T)

figure(plotSu)
hold on
sigmaplot(S_u)

%% Third guess

%Define controller
L_y = [1 0;0 10];
L_r = L_y;

[G_cl, S, T, S_u] = getStabilityFunc(G, L_y, L_r);

pole(G_cl)

legendArray = [legendArray;
    strcat( "k_1 = ", ...
            num2str(L_y(1,1)), ...
            ", k_2 = ", ...
            num2str(L_y(2,2)))];

%Plot singular values
figure(plotCL)
hold on
sigmaplot(G_cl)
legend(legendArray)
hold off

figure(plotS)
hold on
sigmaplot(S)
legend(legendArray)
hold off

figure(plotT)
hold on
sigmaplot(T)
legend(legendArray)
hold off

figure(plotSu)
hold on
sigmaplot(S_u)
legend(legendArray)
hold off

%% Save figures

figFolder = "figures";
mkdir(figFolder)
saveas(plotCL, fullfile(figFolder, 'plotCL.png'))
saveas(plotS, fullfile(figFolder, 'plotS.png'))
saveas(plotT, fullfile(figFolder, 'plotT.png'))
saveas(plotSu, fullfile(figFolder, 'plotSu.png'))
saveas(poleZeroFigure, fullfile(figFolder, 'PoleZeros.png'))

%% Calculate stability functions
function [G_c, S, T, S_u] = getStabilityFunc(G, K_y, K_r)

    G_c = minreal((eye(size(G)) + G*K_y) \ (G*K_r));
    S   = minreal((eye(size(G)) + G*K_y) \ eye(size(G)));
    T   = minreal((eye(size(G)) + G*K_y) \ (G*K_y));
    S_u = minreal((eye(size(G)) + K_y*G) \ eye(size(G)));
end
