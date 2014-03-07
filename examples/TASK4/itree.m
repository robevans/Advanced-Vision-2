% interpretation tree - match model and data features until Limit are 
% successfully paired or can never get Limit
% numM - number of model features
% mlevel - last matched model feature
% Limit - early termination threshold
% pairs(:,2) - paired model-data features
% numpairs - number of paired features so far
% numD - number of data featurses
function success=itree(numM,mlevel,Limit,pairs,numpairs,numD, Kl, Kr, Pl, Pr)

  global paircount modelline line3d line3a drawcount

  % check for termination conditions
  if numpairs >= Limit		% enough pairs to verify
   trypairs = pairs(1:numpairs,:);

    modelline(pairs(1:numpairs,1),:);
    line3d(pairs(1:numpairs,2),:);
    line3a(pairs(1:numpairs,2),:);
    paircount = paircount + 1;
%toestimate=1
    [success,Rot,trans] = estimatepose(numpairs,pairs);
    if success

      % report solution
      pairs(1:numpairs,:)
      Rot
      trans

      % prepare figures for drawing
      close all
      left = imread('left.jpg','jpg');
      left = rgb2gray(left);
      left = imrotate(left, 90);
      lefth = imresize(left,0.25);
      right = imread('right.jpg','jpg');
      right = rgb2gray(right);
      right = imrotate(right, 90);
      righth = imresize(right,0.25);
      figure(400)
      imshow(lefth)
      hold on
      figure(500)
      imshow(righth)
      hold on

      linecolor = {'g-', 'b-', 'r-', 'm-', 'c-', 'y-', 'k-'};
      for jk =1:numpairs
    	Tl = -1:0.1:1;
%	figure(600)
        hold on
    	Px = line3a(pairs(jk,2),1) + Tl.*line3d(pairs(jk,2),1);
    	Py = line3a(pairs(jk,2),2) + Tl.*line3d(pairs(jk,2),2);
   	Pz = line3a(pairs(jk,2),3) + Tl.*line3d(pairs(jk,2),3);
%    	plot3(Px(:),Py(:),Pz(:),linecolor{mod(jk,10)});
	Px = [modelline(pairs(jk,1),1); modelline(pairs(jk,1),4)];
	Py = [modelline(pairs(jk,1),2); modelline(pairs(jk,1),5)];
	Pz = [modelline(pairs(jk,1),3); modelline(pairs(jk,1),6)];
	Pm = [Rot trans']*[Px Py Pz ones(2,1)]';
	Pm = Pm'; %'
%	plot3(Pm(:,1),Pm(:,2),Pm(:,3),linecolor{mod(jk,7)+1});

	p1 = Kl*Pl*[Pm(1,:) 1]';
	p1 = p1' / p1(3);
	p2 = Kl*Pl*[Pm(2,:) 1]';
	p2 = p2' / p2(3);
	figure(400)
	presline = [p1;p2];
	plot(presline(:,1)/4,presline(:,2)/4,linecolor{mod(jk,7)+1})

	p1 = Kr*Pr*[Pm(1,:) 1]';
	p1 = p1' / p1(3);
	p2 = Kr*Pr*[Pm(2,:) 1]';
	p2 = p2' / p2(3);
	figure(500)
	presline = [p1;p2];
	plot(presline(:,1)/4,presline(:,2)/4,linecolor{mod(jk,7)+1})
      end
      drawcount = drawcount+1;
    end

    success=0;    % set to zero to force backtracking for other solutions
    return
  end
  if numpairs + numM - mlevel < Limit	% never enough pairs
    success=0;
    return
  end

  % normal case - see if we can extend pair list
  mlevel = mlevel+1;
  for d = 1 : numD	% try all data lines

    if unarytest(mlevel,d)
      % do all binary tests
      passed=1;
      for p = 1 : numpairs
        if ~binarytest(mlevel,d,pairs(p,1),pairs(p,2))
          passed=0;
          break
        end
      end

      % passed all tests, so add to matched pairs and recurse
      if passed
	pairs(numpairs+1,1)=mlevel;
	pairs(numpairs+1,2)=d;
	success = itree(numM,mlevel,Limit,pairs,numpairs+1,numD,Kl, Kr, Pl, Pr);
	if success
	  return
	end
      end
    end
  end

  % wildcard case - go to next model line
  success = itree(numM,mlevel,Limit,pairs,numpairs,numD, Kl, Kr, Pl, Pr);
