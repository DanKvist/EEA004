%--------------------------------------------------------
%% Question 3 - Plot the singular values
% Plot the poles and confirm system is stable
%--------------------------------------------------------

fig1 = figure;
pzmap(G_ss);

fig2 = figure;
sigma(G_ss);

figFolder = "figures";
mkdir(figFolder)
saveas(fig1, fullfile(figFolder, 'systemPoles.png'))
saveas(fig2, fullfile(figFolder, 'systemSingular.png'))