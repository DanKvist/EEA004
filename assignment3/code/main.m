%% Assignement main script
% Designed to execute all other relevant scripts for the assignment

%run('exampleCode.m')
clear all;
close all;
clc;

G1 = tf(1, [1 1 1])
G2 = tf(1, [1 3])
Kvs = [1 1.6 2.5 4 6.3 10 16];

figure
nyquist(Kvs*G1*G2)

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