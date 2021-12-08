%--------------------------------------------------------
% Run task2 simulation and extract figure data
%--------------------------------------------------------

sim("Coupled_drives_task2a.slx");

x1=ScopeData.time;
y1=ScopeData.signals(:,1).values;

x2=ScopeData.time;
y2=ScopeData.signals(:,2).values;

fig1 = figure;
plot(x1,y1,x2,y2);
grid;
title("Tachometer, Tension");
xlabel("Time (s)");
ylabel("Amplitude");
legend("Tachometer", "Tension")

figFolder = "figures";
mkdir(figFolder)
saveas(fig1, fullfile(figFolder, 'task2a.png'))

%

sim("Coupled_drives_task2b.slx");

x1=ScopeData.time;
y1=ScopeData.signals(:,1).values;

x2=ScopeData.time;
y2=ScopeData.signals(:,2).values;

fig1 = figure;
plot(x1,y1,x2,y2);
grid;
title("Tachometer, Tension");
xlabel("Time (s)");
ylabel("Amplitude");
legend("Tachometer", "Tension")

figFolder = "figures";
mkdir(figFolder)
saveas(fig1, fullfile(figFolder, 'task2b.png'))
