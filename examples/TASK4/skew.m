% compute the 3*3 skew matrix for a given 3 vector
function S = skew(v)
	S = [  0  -v(3)  v(2);
	     v(3)    0  -v(1);
	    -v(2)  v(1)    0];
end
