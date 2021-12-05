%--------------------------------------------------------
%% Question 4 - Check observability and controllability
% Find the controlability matrix and observability matrix 
% and confirm they are full rank.
%--------------------------------------------------------

S = ctrb(G_ss)
O = obsv(G_ss)

unco =  min(size(S)) - rank(S)
unob =  min(size(O)) - rank(O)
