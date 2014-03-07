% perform edge detection and RANSAC line fitting on left and right images
% Produces a set of lines and associated parameters stored in ransaclines.mat

clear all
rand('state',300)

%load linesfound  llinecount llinea llinem llinel llineg llinet llined rlinecount rlinea rlinem rlinel rlineg rlinet rlined

  % get left image
  left = imread('left.jpg','jpg');
  left = rgb2gray(left);
  leftr = imrotate(left, 90);
  img_input_size = size(leftr);
  img_input_size = [img_input_size(2) img_input_size(1)];

% left image edges, cleared at edges
  leftedges = edge(leftr,'canny',[],4);
  leftedges(:,1:50) = zeros(2304,50); % zero left edge
  leftedges(:,3407:3456) = zeros(2304,50); % right edge
  leftedges(1:50,:) = zeros(50,3456); % top edge
  leftedges(2255:2304,:) = zeros(50,3456); % bottom edge
  leftedges(:,1480:2300)=zeros(2304,2300-1480+1); % zero middle of image
  [lr,lc] = find(leftedges==1);

  % show the edges
  figure(101)
  imshow(leftr)
  figure(102)
  clf
  hold on
  axis([0 img_input_size(1) 0 img_input_size(2)])
  [R,C]=size(lr);
  for i = 1:R
   plot(lc(i),img_input_size(2)-lr(i),'k*')
  end
  figure(13)
  clf
  title('left image lines found by RANSAC')
  hold on
  axis([0 img_input_size(1) 0 img_input_size(2)])
  for i = 1:R
   plot(lc(i),img_input_size(2)-lr(i),'k*')
  end

  % get right image
  right = imread('right.jpg','jpg');
  right = rgb2gray(right);
  rightr = imrotate(right, 90);

  % right image edges, cleared at edges
  rightedges = edge(rightr,'canny',[],4);
  rightedges(:,930:1690)=zeros(2304,1690-930+1);
  rightedges(:,1:50) = zeros(2304,50); % left edge
  rightedges(:,3407:3456) = zeros(2304,50); % right edge
  rightedges(1:50,:) = zeros(50,3456); % top edge
  rightedges(2255:2304,:) = zeros(50,3456); % bottom edge
  [rr,rc] = find(rightedges==1);

  % show the edges
  figure(103)
  imshow(rightr)
  figure(104)
  clf
  hold on
  axis([0 img_input_size(1) 0 img_input_size(2)])
  [R,C]=size(rr);
  for i = 1:R
   plot(rc(i),img_input_size(2)-rr(i),'k*')
  end
  figure(15)
  title('right image lines found by RANSAC')
  clf
  hold on
  axis([0 img_input_size(1) 0 img_input_size(2)])
  for i = 1:R
   plot(rc(i),img_input_size(2)-rr(i),'k*')
  end

  % find left lines using RANSAC
  figure(4)
  clf
         title('overlay of left image lines - from RANSAC')
  plot(lc,lr,'k.')
  axis ij
  hold on
  
  flag = 1;
  sr = lr;
  sc = lc;
  llinecount = 0;
  llinea = zeros(100,2);
  llinem = zeros(100,2);
  llinel = zeros(100,1);
  llineg = zeros(100,1);
  llinet = zeros(100,1);
  llined = zeros(100,1);
  while flag == 1    % loop to find all lines
    [flag,t,d,nr,nc,count,frl,fcl,newcountl] = ransacline3(sr,sc,2.5,0.1,0.01,0.001,130,3,img_input_size);
    if flag == 1 & newcountl > 0 % if long enough line
      pointsleft = size(nr);
      sr = nr;
      sc = nc;
      llinecount = llinecount+1;
      [llinea(llinecount,:),llinem(llinecount,:),llinel(llinecount), ...
            llineg(llinecount)] = descrseg(frl,fcl,leftr,4);
      llinet(llinecount) = t;
      llined(llinecount) = d;

      [cr,cc] = plotline3(t,d, img_input_size);
      figure(4)
      plot(cc,cr)
      pause(0.1) 
      llinecount
    end
  end
  
  %% remove semi-colons on following lines to see printout of leftt lines
  llinea(1:llinecount,:);
  llinem(1:llinecount,:);
  llinel(1:llinecount);
  llineg(1:llinecount);
  llinet(1:llinecount);
  llined(1:llinecount);
['Left image processed - RANSAC lines found. Press return for right image']
 
  % find right lines
  figure(6)
  clf
  plot(rc,rr,'k.')
  title('overlay of right image lines - from RANSAC')
  axis([0 img_input_size(1) 0 img_input_size(2)])
  axis ij
  hold on
    
  flag = 1;
  sr = rr;
  sc = rc;
  rlinecount = 0;
  rlinea = zeros(100,2);
  rlinem = zeros(100,2);
  rlinel = zeros(100,1);
  rlineg = zeros(100,1);
  rlinet = zeros(100,1);
  rlined = zeros(100,1);
  while flag == 1    % loop until all found
    [flag,t,d,nr,nc,count,frr,fcr,newcountr] = ransacline3(sr,sc,2.5,0.1,0.01,0.001,130,5,img_input_size);
    if flag == 1 & newcountr > 0 % if long enough
      pointsleft = size(nr);
      sr = nr;
      sc = nc;
      rlinecount = rlinecount+1;
      [rlinea(rlinecount,:),rlinem(rlinecount,:),rlinel(rlinecount), ...
            rlineg(rlinecount)] = descrseg(frr,fcr,rightr,4);
      rlinet(rlinecount) = t;
      rlined(rlinecount) = d;
      [cr,cc] = plotline3(t,d, img_input_size);
      figure(6)
      plot(cc,cr)
      pause(0.1)    
      rlinecount
    end
  end
  
  %% remove semi-colons on following lines to see printout of right lines
  rlinea(1:rlinecount,:);
  rlinem(1:rlinecount,:);
  rlinel(1:rlinecount);
  rlineg(1:rlinecount);
  rlinet(1:rlinecount);
  rlined(1:rlinecount);
['right image processed - RANSAC lines found. run stage2 to do stereo recognition']

save ransaclines rlinecount rlinea rlinem rlinel rlineg rlinet rlined llinecount llinea llinem llinel llineg llinet llined

NumLeftLines=llinecount
NumRightLines=rlinecount
