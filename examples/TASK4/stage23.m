
global line3d modelline line3a paircount verifycount drawcount llinem rlinem llinecount rlinecount
load fund_cam.mat
Fund = T'*F*T;     %'

%% perform stereo correspondance, triangulation and recognition against
%% a pre-known model

% load left image and re-calculate edges for later display
left = imread('left.jpg','jpg');
left = rgb2gray(left);
leftr = imrotate(left, 90);
img_input_size = size(leftr);
lefth = imresize(leftr,0.25);
leftedges = edge(leftr,'canny',[],4);
leftedges(:,1:50) = zeros(2304,50); % left edge
leftedges(:,3407:3456) = zeros(2304,50); % right edge
leftedges(1:50,:) = zeros(50,3456); % top edge
leftedges(2255:2304,:) = zeros(50,3456); % bottom edge
leftedges(:,1480:2300)=zeros(2304,2300-1480+1); % zero middle of image
[lr,lc] = find(leftedges==1);
figure(133)
clf
hold on
axis([0 img_input_size(2)/4 0 img_input_size(1)/4])
axis ij
[R,C]=size(lr);
for i = 1:R
   plot(lc(i)/4,lr(i)/4,'k*')
end

% load right image and re-calculate edges for later display
right = imread('right.jpg','jpg');
right = rgb2gray(right);
rightr = imrotate(right, 90);
righth = imresize(rightr,0.25);
rightedges = edge(rightr,'canny',[],4);
rightedges(:,1:50) = zeros(2304,50); % left edge
rightedges(:,3407:3456) = zeros(2304,50); % right edge
rightedges(1:50,:) = zeros(50,3456); % top edge
rightedges(2255:2304,:) = zeros(50,3456); % bottom edge
rightedges(:,930:1690)=zeros(2304,1690-930+1);   % clear central area
[lr,lc] = find(rightedges==1);
figure(135)
clf
hold on
axis([0 img_input_size(2)/4 0 img_input_size(1)/4])
axis ij
[R,C]=size(lr);
for i = 1:R
   plot(lc(i)/4,lr(i)/4,'k*')
end

% find potential pairings
linepairs = zeros(100,2);
numpairs=0;
Tep = 300;         % correspondence constraint thresholds - epipolar
Tdisl = 500;       % low disparity
Tdish = 700;       % high disparity
Tlen = 0.30;       % length conparison
Tort = .9;         % orientation comparison
Tcon = 30;         % contrast comparison
Tminoverlap = 55;  % min overlap length

% show left RANSAC lines on image
figure(10)
clf
imshow(lefth)
axis ij
hold on
%	 for l = 1 : llinecount
for l = [1,6,14,24,25,31,42,44,55,60,64,65,70,83,84,92] % subset of wedge lines
  [cr,cc] = plotlineh(llinet(l),llined(l)/4);
  plot(cc,cr)
  plot(llinem(l,2)/4,llinem(l,1)/4,'r*')
end
pause


% show right RANSAC lines on image
figure(11)
clf
imshow(righth)
axis ij
hold on
%	 for r = 1 : 108
for r = [9,23,27,28,30,46,51,64,68,72,74,75,91,93,95,105] %subset of wedge lines
  [cr,cc] = plotlineh(rlinet(r),rlined(r)/4);
  plot(cc,cr)
  plot(rlinem(r,2)/4,rlinem(r,1)/4,'r*')
end
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% look at all left:right line pairs that satisfy constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for l = [1,6,14,24,25,31,42,44,55,60,64,65,70,83,84,92] %1 : llinecount
for r = [9,23,27,28,30,46,51,64,68,72,74,75,91,93,95,105] %1 : rlinecount
%for l = 1 : llinecount
%for r = 1 : rlinecount

  % test orientation constraint
  if (abs(llinea(l,:)*rlinea(r,:)')  > Tort)    % ' passed direction test

    % now check for 3D overlap
    % core idea is to find longest segment in both images along epipolar
    % lines. If length is not enough, then reject. 
    pliner = projectiveline([rlinem(r,2) rlinem(r,1)], [rlinea(r,2) rlinea(r,1)]);
    [cr,cc] = plotline3(llinet(l),llined(l), img_input_size); % left image points
    cc = round(cc);
    cr = round(cr);
    maxpts=0;
    foundline=0;
    starti=0;
    endi=0;
    maxstarti=-1;
    maxendi=-1;
    maxlengthi=-1;
    for ii = 1 : length(cc) % test all points along line - pointtestloop
	  % is current point near image edges? 8 cases:
      % 1) already tracking & left near & right near -> extend
      % 2) already tracking & left not near & right near -> finish track and keep longest
      % 3) already tracking & left near & right not near -> finish track and keep longest
      % 4) already tracking & left not near & right not near -> finish track and keep longest
      % 5) not already tracking & left near & right near -> start track
      % 6) not already tracking & left not near & right near -> continue to next point
      % 7) not already tracking & left near & right not near -> continue to next point
      % 8) not already tracking & left not near & right not near -> continue to next point
      pr=skew(pliner)*Fund*[cc(ii),cr(ii),1]'; %' predict corresponding right image where epipolar line from left intersects right line
      pr = round(pr / pr(3));
      nel = nearedge(cr(ii),cc(ii),leftedges,4);   % an image edge pixel in the left image?
      ner = nearedge(pr(2),pr(1),rightedges,4);    % an image edge pixel in the right image?

      if foundline==0 && (nel==0 || ner==0) % case 6,7,8 - nothing to track
        continue
      end
      if foundline==1 && (nel==0 || ner==0) % case 2,3,4 - finish track
	    lengthi = endi-starti;
        if maxlengthi < 0  % nothing found so far
          maxstarti = starti;
          maxendi = endi;
          maxlengthi = maxendi - maxstarti;
        elseif lengthi > maxlengthi % found longer
          maxstarti = starti;
          maxendi = endi;
          maxlengthi = maxendi - maxstarti;
        end
        foundline=0;
      end
      if foundline==1 && nel==1 && ner==1 % case 1 - extend track
        endi=ii;
      end
      if foundline==0 && nel==1 && ner==1 % case 5 - start track
	    starti=ii;
        endi=ii;
        foundline=1;
      end
    end % of points along paired lines for 3D overlap test

    % test for enough overlap
    if  maxlengthi < Tminoverlap   % min overlap test
      nothingfound=1;
    else
      foundseg=[cc(maxstarti),cr(maxstarti),cc(maxendi),cr(maxendi)]

      % recompute segment midpoints
      for ii = maxstarti:maxendi
        pr=skew(pliner)*Fund*[cc(ii),cr(ii),1]'; %' predict corresponding right image where epipolar line from left intersects right line
        pr = round(pr / pr(3));
        ppc(ii)=pr(1);
        ppr(ii)=pr(2);
      end
      testllinem=[cr(floor((maxstarti+maxendi)/2)),cc(floor((maxstarti+maxendi)/2))];
      testrlinem=[ppr(floor((maxstarti+maxendi)/2)),ppc(floor((maxstarti+maxendi)/2))];

      % compute contrast
      lcon=0;
      rcon=0;
      ccount=0;
      for i = 5 : 15  % accumulate intensity difference in perpendicular direction to midpoint
                       % use unpacked form due to some weird matlab bug
        lc1=floor(testllinem(2) - i*llinea(l,1));
        lc2=floor(testllinem(2) + i*llinea(l,1));
        lr1=floor(testllinem(1) + i*llinea(l,2));
        lr2=floor(testllinem(1) - i*llinea(l,2));
        rc1=floor(testrlinem(2) - i*rlinea(r,1));
        rc2=floor(testrlinem(2) + i*rlinea(r,1));
        rr1=floor(testrlinem(1) + i*rlinea(r,2));
        rr2=floor(testrlinem(1) - i*rlinea(r,2));
        if (lr1<1)||(lr2<1)||(rr1<1)||(rr2<1)
          continue
        end
        if (lc1<1)||(lc2<1)||(rc1<1)||(rc2<1)
          continue
        end
        if (lr1>img_input_size(1))||(lr2>img_input_size(1))||(rr1>img_input_size(1))||(rr2>img_input_size(1))
          continue
        end
        if (lc1>img_input_size(2))||(lc2>img_input_size(2))||(rc1>img_input_size(2))||(rc2>img_input_size(2))
          continue
        end
        lv1 = double(leftr(lr1,lc1));
	    lv2 = double(leftr(lr2,lc2));
	    lcon = lcon + lv1 - lv2;
        rv1=double(rightr(rr1,rc1));
	    rv2=double(rightr(rr2,rc2));
	    rcon = rcon + rv1 - rv2;
        ccount = ccount + 1;
      end
      if ccount==0
	    ccount=1;
      end
      lcon = lcon/ccount;
      rcon = rcon/ccount;

      % test disparity and contrast
      if abs(testllinem(2) - testrlinem(2)) > Tdisl ...    %min disparity - disparitytest
         && abs(testllinem(2) - testrlinem(2)) < Tdish ... %max disparity
         && abs(lcon - rcon) < Tcon                    % contrast difference
        numpairs = numpairs+1;
        linepairs(numpairs,1)=l;
        linepairs(numpairs,2)=r;
        llinem(l,:)=testllinem;      % warning - may get overwritten later
        rlinem(r,:)=testrlinem;
        figure(133)
        plot(cc(maxstarti:maxendi)/4,cr(maxstarti:maxendi)/4,'r*')
        figure(135)
        plot(ppc(maxstarti:maxendi)/4,ppr(maxstarti:maxendi)/4,'r*')

      end % end of disparitytest
    end % end of minoverlaptest
  end % end of passeddirectiontest
end %r line loops
end %l line loops
bestlinep=linepairs(1:numpairs,:)
llinem(linepairs(1:numpairs,1),:)
rlinem(linepairs(1:numpairs,2),:)

pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enforce uniqueness and other constraints
% extracts only unique use of the left line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pairs = 0;      
pairlist = zeros(100,2);
changes = 1;
while changes
 changes = 0;
 for l = 1 : numpairs
  if linepairs(l,1) > 0
   testset = find(linepairs(:,1)==linepairs(l,1));
   if length(testset) == 1 
     changes = 1;
     pairs = pairs + 1;
     pairlist(pairs,1) = linepairs(l,1);
     pairlist(pairs,2) = linepairs(l,2);
     linepairs(testset(1),:) = zeros(1,2); % clear taken
   end
  end
 end
end
bestpairs=pairlist(1:pairs,:)

pause

%%%%%%%%%%%%%%%%
%
% draw lines that pass the constraints
% leftcons/rightcons
%
%%%%%%%%%%%%%%%%
linecolor = {'g-', 'b-', 'r-', 'm-', 'c-', 'y-', 'k-'};
markcolor = {'g+', 'b+', 'r+', 'm+', 'c+', 'y+', 'k+'};
figure(33)
clf 
imshow(lefth)
hold on
axis ij
figure(35)
clf 
imshow(righth)
hold on
axis ij
for l = 1 : pairs
  figure(33)
  [cr,cc] = plotlineh(llinet(pairlist(l,1)),llined(pairlist(l,1))/4);
  plot(cc,cr)
  plot(llinem(pairlist(l,1),2)/4,llinem(pairlist(l,1),1)/4,'r*')
  figure(35)
  [cr,cc] = plotlineh(rlinet(pairlist(l,2)),rlined(pairlist(l,2))/4);
  plot(cc,cr)
  plot(rlinem(pairlist(l,2),2)/4,rlinem(pairlist(l,2),1)/4,'r*')
end

pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute 3D lines thru the pairs by intersecting planes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(100)
imshow(lefth)
hold on
figure(200)
imshow(righth)
hold on
figure(300)
clf
plot3(0,0,0,'b.');
hold on

alpha = 1500;
line3a = zeros(numpairs,3);
line3d = zeros(numpairs,3);

Plinel = [];
Pliner = [];
for i = 1 : pairs

  %compute projective lines for each 2D pair
  midpointl   = [llinem(pairlist(i,1),2) llinem(pairlist(i,1),1)  1];
  mipointdirl = 10*[llinea(pairlist(i,1),2) llinea(pairlist(i,1),1) 0];  % was *10 - why?
  midpointr   = [rlinem(pairlist(i,2),2) rlinem(pairlist(i,2),1)  1];
  mipointdirr = [rlinea(pairlist(i,2),2) rlinea(pairlist(i,2),1) 0];
  plinel = projectiveline([llinem(pairlist(i,1),2) llinem(pairlist(i,1),1)], [llinea(pairlist(i,1),2) llinea(    pliner = projectiveline([rlinem(pairlist(i,2),2) rlinem(pairlist(i,2),1)], [rlinea(pairlist(i,2),2) rlinea(    Plinel = [Plinel; plinel];
  Pliner = [Pliner; pliner];

  % predict midpoint position in opposite image
  midpointrr    = skew(pliner)*Fund*midpointl';
  midpointrr    = midpointrr' / midpointrr(3);
  midpointdirrr = skew(pliner)*Fund*(midpointl+mipointdirl)';  % project 2nd left point along line into right
  midpointdirrr = midpointdirrr'/ midpointdirrr(3);
 
  midpointll = skew(plinel)*Fund'*midpointr';
  midpointll = midpointll / midpointll(3);

  % plot corresponding midpoints on left & right images
  figure(100)
  quiver(llinem(pairlist(i,1),2), llinem(pairlist(i,1),1), 50*llinea(pairlist(i,1),2), 50*llinea(pairlist(i,1),1),linecolor{mod(i,7)+1});
  plot(midpointl(1)/4, midpointl(2)/4, 'b+'); % plot left line
  plot(midpointll(1)/4, midpointll(2)/4, 'y+');
  figure(200)
  quiver(rlinem(pairlist(i,2),2), rlinem(pairlist(i,2),1), 50*rlinea(pairlist(i,2),2), 50*rlinea(pairlist(i,2),1),linecolor{mod(i,7)+1});
  plot(midpointr(1)/4, midpointr(2)/4, 'b+'); % plot right line
  plot(midpointrr(1)/4, midpointrr(2)/4, 'y+');

  % compute and plot 3d line
  figure(300)
  X1 = triangulate(midpointl, midpointrr,Kl, Kr, Pl, Pr);
  plot3(X1(1),X1(2),X1(3),markcolor{mod(i,7)+1});
  X2 = triangulate(midpointl+mipointdirl, midpointdirrr,Kl, Kr, Pl, Pr);
  plot3(X2(1),X2(2),X2(3),markcolor{mod(i,7)+1});
  p3d = X1;
  pdir = X2-X1;
  pdir = pdir / norm(pdir);
  %[p3d pdir] = backprojectinter(plinel, pliner, Kl, Kr, Pl, Pr);
  %[p3d pdir] = backprojectinterf(plinel, pliner, Fund, Kl, Kr);
  Tl = -1:0.1:1;
  Px = p3d(1) + Tl.*pdir(1);
  Py = p3d(2) + Tl.*pdir(2);
  Pz = p3d(3) + Tl.*pdir(3);
  plot3(Px(:),Py(:),Pz(:),linecolor{mod(i,7)+1});
  line3d(i,:) = pdir;
  line3a(i,:) = p3d;
end
line_dirs = line3d(1:pairs,:)
line_pts = line3a(1:pairs,:)

% test angles between reconstructed 3D line pairs
dots = zeros(100,3);
tmp=0;
for i = 1 : pairs-1
 for j = i+1 : pairs
   tmp = tmp+1;
   dots(tmp,:) = [i,j,acos(abs(line3d(i,:)*line3d(j,:)'))]; %'
 end
end
dots(1:tmp,:)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% match data lines to model lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

model;      % load model
mzero = modelline ~= 0;  % overwrite model dimensions
modelline(mzero) = 5.7;
modelline = modelline / 8.65;
modelline

% set up interpretation tree
matchpairs = zeros(100,2);
paircount=0;
verifycount=0;
drawcount=0;			       
success = itree(9,0,8,matchpairs,0,pairs, Kl, Kl, Pl, Pr);
if success
    ['model recognised in this image']
end
if ~success
  ['no models recognised in this image']
end

paircount
verifycount
drawcount
