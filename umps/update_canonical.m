function [A_left,A_right] = update_canonical(A,C_left,C_right)

[D,~,d] = size(A);
% Reshape A into matrices
A_left = reshape(permute(A,[1,3,2]),[d*D,D]);
A_right = reshape(A,[D,d*D]);
% Use polar decomposition
[UC_left,~,VC_left] = svd(C_left,'econ');
if nargin == 3
	[UC_right,~,VC_right] = svd(C_right,'econ');
else
	UC_right = UC_left;
	VC_right = VC_left;
end
[UA_left,~,VA_left] = svd(A_left,'econ');
[UA_right,~,VA_right] = svd(A_right,'econ');
A_left = permute(reshape(UA_left*VA_left'*VC_right*UC_right',[D,d,D]),[1,3,2]);
A_right = reshape(VC_left*UC_left'*UA_right*VA_right',[D,D,d]);
end
