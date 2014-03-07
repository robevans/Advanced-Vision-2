% sees if there is an edge pixel within tol of binary edgeimage(r,c)
function near = nearedge(r,c,edgeimage,tol)

   [mr,mc]=size(edgeimage);
   if (r-tol < 1)||(r+tol > mr)||(c-tol < 1)||(c+tol > mc)
      near = 0;
   else
      near = max(max(edgeimage(r-tol:r+tol,c-tol:c+tol)));
   end
