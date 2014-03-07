% compute 2D projective line equation for the line thru point X with direction v
%input
%X image point coordinates
%v line direction (vector)
%output
%l projective line
function l = projectiveline(X,v)
	nn = [v(2), -v(1)]; % 90 degree rotation to get the normal vector
	%a = nn(1)
	%b = nn(2)
	%c = -dot(nn,X)
	%l = [a b c] <---- equation of projective line
	l = [nn(1), nn(2), -dot(nn,X)];
end
