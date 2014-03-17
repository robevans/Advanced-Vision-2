
function [ output_args ] = save_figure_bin_rgb_depth_points(frame,  prefix, number )


rgbd_points = frame';
set(0,'DefaultFigureRenderer','opengl')
% set colourmap
% unit^2 area per point to plot
markerSize = 9;
S = ones(length(rgbd_points),1) * markerSize;
% scatter plot our coloured point cloud

h =  figure('Visible','Off');
% unit^2 area per point to plot
% scatter plot our coloured point cloud
scatter3(rgbd_points(:,1),rgbd_points(:,2),rgbd_points(:,3),S(:),1:length(rgbd_points),'filled');
colormap(gca,rgbd_points(:,4:6)/255);
view(0, 90)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_rgb_depth_image_side'), 'epsc');

close all;
h =  figure('Visible','Off');
scatter3(rgbd_points(:,1),rgbd_points(:,2),rgbd_points(:,3),S(:),1:length(rgbd_points),'filled');
colormap(gca,rgbd_points(:,4:6)/255);
view(0, 0)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_rgb_depth_image_top'), 'epsc');
end

