%--------------------------------------------------------
%% Question 4 - Check observability and controllability
% Find the controlability matrix and observability matrix 
% and confirm they are full rank.
%--------------------------------------------------------

%rank(ctrb(G_ss))
%rank(obsv(G_ss))

unco = length(G_ss.a) - rank(ctrb(G_ss))
unob = length(G_ss.a) - rank(obsv(G_ss))

%TODO: what do we do with this? Print a warning?