%% Heater & Humidifier assignment

G_u1y1 = tf(15, [50 1]);
G_u1y2 = tf(-25, [50 1]);
G_u2y1 = tf(-10, [10 1]);
G_u2y2 = tf(70, [10 1]);

G = [G_u1y1 G_u1y2;G_u2y1 G_u2y2]