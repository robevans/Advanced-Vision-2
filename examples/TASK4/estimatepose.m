% estimates the transformation that maps a given set of
% model vectors onto a set of data vectors
function [success,Rot,trans] = estimatepose(numpairs,pairs)

  global modelline line3d line3a

  % the problem is we dont know which way the model
  % lines should be facing to correspond with the data
  % lines. So we try all 2^numpairs direction pairs
  factors = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096]; % combinations
  success=0;
  Rot = zeros(3,3);
  trans = zeros(1,3);
  rthreshold = 0.8;

  for j = 0 : factors(numpairs+1)-1      % loop over all directions

    % estimate rotation matrix by SVD
    M = zeros(3,numpairs);
    D = zeros(3,numpairs);
    for i = 1 : numpairs
      n = modelline(pairs(i,1),1:3) - modelline(pairs(i,1),4:6);
      n = n / norm(n);
      if bitand(fix(factors(i)),fix(j)) ~= 0
        n = -n;
      end
      M(:,i) = n';               %'
      d = line3d(pairs(i,2),1:3);
      D(:,i) = d';                %'
    end
    [U,DG,V] = svd(D*M');              %'
    Rot = U*V';              %'
    if det(Rot) < 0     
      F = eye(3);
      F(3,3) = -1;
      Rot = F*Rot;
   end
  
    % test estimated rotation matrix by ensuring Di = Rot*Mi
    allpass = 1;
    for i = 1 : numpairs
      dot = D(:,i)'*Rot*M(:,i);         %'
      if dot < rthreshold
        allpass = 0;
        break
      end
    end

    % if have a good rotation, then estimate translation by least squares
    if allpass == 1

      L = zeros(3,3);
      N = zeros(3,1);
      for i = 1 : numpairs
        d = line3d(pairs(i,2),1:3);
        b = line3a(pairs(i,2),1:3)';         %'
        a = modelline(pairs(i,1),1:3)';         %'
        F = eye(3)-d'*d;         %'
        L = L + F'*F;         %'
        N = N + F'*F*(Rot*a-b);         %'
      end
      trans = -(inv(L)*N)';         %'

      % check for good translation
      success = verifymatch(Rot,trans,numpairs,pairs);
      if success == 1
        return
      end
    end
  end

