%% Assignement main script
% Configuration
clear all;
close all;
clc;

%For saving figures
figFolder = "figures";
mkdir(figFolder)

%
G1 = tf(1, [1 1 1])
G2 = tf(1, [1 3])
Kvs = [1 1.6 2.5 4 6.3 10 16];

%
k1 = 1/0.6;
k2 = 0.6;
m=((1/k1)+(1/k2))/2;
r=abs(((1/k1)-(1/k2))/2);

fig1 = figure(1);
nyquist(Kvs(1)*G1*G2)
circle(m,r);
saveas(fig1, fullfile(figFolder, 'nyquist1.png'))

fig2 = figure(2);
nyquist(Kvs(2)*G1*G2)
circle(m,r);
saveas(fig2, fullfile(figFolder, 'nyquist2.png'))

fig3 = figure(3);
nyquist(Kvs(3)*G1*G2)
circle(m,r);
saveas(fig3, fullfile(figFolder, 'nyquist3.png'))

fig4 = figure(4);
nyquist(Kvs(4)*G1*G2)
circle(m,r);
saveas(fig4, fullfile(figFolder, 'nyquist4.png'))

fig5 = figure(5);
nyquist(Kvs(5)*G1*G2)
circle(m,r);
saveas(fig5, fullfile(figFolder, 'nyquist5.png'))

fig6 = figure(6);
nyquist(Kvs(6)*G1*G2)
circle(m,r);
saveas(fig6, fullfile(figFolder, 'nyquist6.png'))

fig7 = figure(7);
nyquist(Kvs(7)*G1*G2)
circle(m,r);
saveas(fig7, fullfile(figFolder, 'nyquist7.png'))

%G_cl = feedback(Kvs*G1*G2,[1 1 1 1 1 1 1]')

G_cl1 = feedback(Kvs(1)*G1*G2,1)
G_cl2 = feedback(Kvs(2)*G1*G2,1)
G_cl3 = feedback(Kvs(3)*G1*G2,1)
G_cl4 = feedback(Kvs(4)*G1*G2,1)
G_cl5 = feedback(Kvs(5)*G1*G2,1)
G_cl6 = feedback(Kvs(6)*G1*G2,1)
G_cl7 = feedback(Kvs(7)*G1*G2,1)

%pzmap( G_cl1, G_cl2)
%pzmap( G_cl(1), G_cl(2))
figure
pzmap(G_cl1, G_cl2, G_cl3, G_cl4, G_cl5, G_cl6, G_cl7)

%
% Draw a circle at location -m with radius r.
function circle (m,r)
    hold on;
    fi=(-1:0.01:1)*pi;
    x=-m+r*exp(1i*fi);
    plot(x);
    plot([(-m+r) (-m+r)], [-10 10])
    hold off;
end