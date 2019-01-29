function err = gauge_error(A,A_left,A_right,C_left,C_right)
% Returns the maximum between the errors |A*C - A_left|, |A*C - C*A|,
% |C*A - A_right| in Frobenius norm. The result is then normalized by the
% number of elements in A to give a value independent of the bond dimension.
if nargin < 5
	C_right = C_left;
end
AC = [];
CA = [];
if ~isempty(A_left)
	AC = ncon({A_left,C_right},{[-1,1,-3],[1,-2]});
end
if ~isempty(A_right)
	CA = ncon({C_left,A_right},{[-1,1],[1,-2,-3]});
else
	error('A_left and A_right cannot be both empty.');
end
err_vec = zeros(1,3);
if ~isempty(A_left) & ~isempty(A)
	err_vec(1) = norm(AC(:) - A(:));
end
if ~isempty(A_left) & ~isempty(A_right)
	err_vec(2) = norm(AC(:) - CA(:));
end
if ~isempty(A_right) & ~isempty(A)
	err_vec(3) = norm(CA(:) - A(:));
end
err = max(err_vec)/sqrt(numel(A));
end

