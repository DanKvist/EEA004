%% Configuration
clear all;
close all;
clc;

%For saving figures
figFolder = "figures";
mkdir(figFolder)

%% Build system
% Specify the system TF
G1 = tf(1, [1 1 1]);
G2 = tf(1, [1 3]);
Kvs = [1 1.6 2.5 4 6.3 10 16];

%% Circle criterion

% Specify bounding functions
k1 = 1/0.6;
k2 = 0.6;
m=((1/k1)+(1/k2))/2;
r=abs(((1/k1)-(1/k2))/2);

%Check closed loop poles as a sanity check
figure(1)
G_cl1 = feedback(Kvs(1)*G1*G2,1);
G_cl2 = feedback(Kvs(2)*G1*G2,1);
G_cl3 = feedback(Kvs(3)*G1*G2,1);
G_cl4 = feedback(Kvs(4)*G1*G2,1);
G_cl5 = feedback(Kvs(5)*G1*G2,1);
G_cl6 = feedback(Kvs(6)*G1*G2,1);
G_cl7 = feedback(Kvs(7)*G1*G2,1);
pzmap(G_cl1, G_cl2, G_cl3, G_cl4, G_cl5, G_cl6, G_cl7)

labels = ["1","1.6","2.5","4.0","6.3","10","16"];

circFig = figure(8);
plotoptions = nyquistoptions;
plotoptions.XLim = {[-2 2]};
plotoptions.YLim = {[-2 2]};
plotoptions.ShowFullContour = 'off';
for k = 1:length(labels)
    nyquistplot(Kvs(k)*G1*G2, plotoptions);
    hold on
end
hold off
circle(m,r);

legend(labels)

saveas(circFig, fullfile(figFolder, 'circFig.png'))

%% Describing function
descFig = figure(9);
plotoptions = nyquistoptions;
plotoptions.XLim = {[-0.6 0.6]};
plotoptions.YLim = {[-0.6 0.6]};
plotoptions.ShowFullContour = 'off';
for k = 1:length(labels)
    nyquistplot(Kvs(k)*G1*G2, plotoptions);
    hold on
end
hold off

%Add describing function plot for comparison
C = (0:.1:10);
Y = 4 ./ (pi .* C);
YY = -1 ./ Y;
XX = zeros(1,length(C));
hold on
plot(YY,XX,'r','LineWidth',2);
plot(-1/(4/(pi*.5)),0,'ko','LineWidth',2);
quiv = quiver(0,0,-1/(4/(pi*.5)),0,'r','LineWidth',2);
quiv.MaxHeadSize = 0.4;
hold off

legend(labels)

saveas(descFig, fullfile(figFolder, 'descFig.png'))

%% Utilities

%Draw a circle at location -m with radius r.
function circle (m,r)
    hold on;
    fi = (-1:0.01:1)*pi;
    x = -m + r*exp(1i*fi);
    plot(x, 'r','LineWidth',2);
    plot([(-m + r) (-m + r)], [-10 10],'r','LineWidth',2)
    hold off;
end