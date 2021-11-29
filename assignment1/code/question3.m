%% Plot the singular values

pzmap(G_ss) 

saveas(gcf, fullfile(figFolder, 'systemPoles.png'))