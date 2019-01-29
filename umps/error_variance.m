function g = error_variance(A_left,C,A_right,H,B_left,B_right)
% Approximates the energy variance <(H - E)^2> using the two-site variance
% as explained in arXiv:1711.01104.
if ~iscell(H) && ndims(B_left) == 2
	g = error_variance_twosite(A_left,C,A_right,H,B_left,B_right);
	return
elseif iscell(H) & iscell(H{1,1})
	B_mid = applyT(B_right,A_right,H{2},A_right,'r');
else
	H = {H,H};
	B_mid = B_right;
end
% Nullspaces
N_left = nullspace(A_left,'l');
N_right = nullspace(A_right,'r');

AC = ncon({A_left,C},{[-1,1,-3],[1,-2]});
G_left = applyT(B_left,N_left,H{1},AC,'l');
G_right = applyT(B_right,N_right,H{2},A_right,'r');
% First projector

P1 = ncon({G_left,B_mid},{[-1,1,2],[-2,1,2]});
% Second projector
P2 = ncon({G_left,G_right},{[-1,1,2],[-2,1,2]});
g = trace(P1*P1') + trace(P2*P2');
end

function g = error_variance_twosite(A_left,C,A_right,H,B_left,B_right)
% Nullspaces
N_left = nullspace(A_left,'l');
N_right = nullspace(A_right,'r');
% First projector
AC = ncon({A_left,C},{[-1,1,-3],[1,-2]});
A_prime = applyHA(AC,H,B_left,B_right,A_left,A_right,'twosite');
P1 = ncon({conj(N_left),A_prime},{[1,-1,2],[1,-2,2]});
% Second projector
A2s = ncon({AC,A_right},{[-1,1,-2],[1,-4,-3]});
A2s_prime = ncon({A2s,H},{[-1,1,2,-4],[-2,-3,1,2]});
A2s_prime = A2s_prime + ncon({B_left,A2s},{[-1,1],[1,-2,-3,-4]});
A2s_prime = A2s_prime + ncon({A2s,B_right},{[-1,-2,-3,1],[1,-4]});
P2 = ncon({conj(N_left),A2s_prime,conj(N_right)},{[1,-1,2],[1,2,4,3],[-2,3,4]});
g = trace(P1*P1') + trace(P2*P2');
end

