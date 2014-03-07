% angle between a pair of data lines lies within delta of angle between a
% pair of model lines
function success = binarytest(m1,d1,m2,d2)

  global line3d modelline
  binarydelta = 0.50;

  % get model and data direction vectors 
  success = 0;
  if m1 == m2
    return
  end
  if d1 == d2
    return
  end
  vecm1 = modelline(m1,1:3)-modelline(m1,4:6);
  vecm1 = vecm1/norm(vecm1);
  vecm2 = modelline(m2,1:3)-modelline(m2,4:6);
  vecm2 = vecm2/norm(vecm2);
  vecd1 = line3d(d1,:);
  vecd2 = line3d(d2,:);

  % get angles
  angd = acos(vecd1*vecd2'); %'
  if angd > pi/2
    angd = pi - angd;
  end
  angm = acos(vecm1*vecm2'); %'
  if angm > pi/2
    angm = pi - angm;
  end
	      
  % do test
  if abs(angd - angm) <= binarydelta
    success = 1;
  end
