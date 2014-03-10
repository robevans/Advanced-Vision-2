function [  ] = scatter3_kinectxyzrgb( xyzrgb_frame )

% convert from 640x480 image to 307200x6 point list 
xyz  = reshape(xyzrgb_frame(:,:,1:3),640*480,3);
rgb  = reshape(xyzrgb_frame(:,:,4:6),640*480,3);
xyzrgb_frame = [ xyz , rgb ];

% only plot valid points (strip out NaN rows)
ind          = ~any(isnan(xyzrgb_frame),2);
xyzrgb_frame = xyzrgb_frame(ind,:);
% set colourmap
colormap(gca,xyzrgb_frame(:,4:6)/255);
% unit^2 area per point to plot
scalar = 5;
S = ones(length(xyzrgb_frame),1) * scalar;
% scatter plot our coloured point cloud
scatter3(xyzrgb_frame(:,1),xyzrgb_frame(:,2),xyzrgb_frame(:,3),S(:),1:length(xyzrgb_frame),'filled');
% draw full screen
set(gcf, 'Position', [get( 0, 'ScreenSize' )]);

end

