%triangulate points
%input
%K intrinsic parameter camera
%Pl, Pr projection matrix left and right
%xl image coordinates left point
%xr image coordinates right point
%output
% 3D triangulated point X
function X = triangulate(xl, xr, Kl, Kr, Pl, Pr)
	%do linear traingulation
	X = [];
	[m n] = size(xr);
	for i = 1:m
		xlrep = inv(Kl)*[xl(i,1) xl(i,2) 1]';
		xrrep = inv(Kr)*[xr(i,1) xr(i,2) 1]';
		a1 = xlrep(1)*Pl(3,:) - Pl(1,:);
		a2 = xlrep(2)*Pl(3,:) - Pl(2,:);
		a3 = xrrep(1)*Pr(3,:) - Pr(1,:);
		a4 = xrrep(2)*Pr(3,:) - Pr(2,:);
		a1 = a1/norm(a1);
		a2 = a2/norm(a2);
		a3 = a3/norm(a3);
		a4 = a4/norm(a4);
		A = [a1;a2;a3;a4];
		[U S V] = svd(A);
		x = V(:,end);
		x = x / x(4);
		X = [X; x(1:3)'];
	end
end
