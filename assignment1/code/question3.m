%-------------------------------------------------------------------------
%% Plot the singular values
%-------------------------------------------------------------------------

pzmap(G_ss) 

figFolder = "./figures";
saveas(gcf, fullfile(figFolder, 'systemPoles.png'))