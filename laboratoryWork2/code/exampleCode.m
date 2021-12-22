%% Assignement 1: System description and analysis
% This is just an example script to generate some basic test content

%% Setup figure saving

figFolder = 'figures';
mkdir(figFolder);

% Save an example figure
y = 1:10;
plot(y, '*-')
saveas(gcf, fullfile(figFolder, 'exampleFigure.png'))
