function display_textured_scatter_plot(rgbd_points, figHandle)
% Takes a list of RGBD points (N x [X, Y, Z, R G B ] matrix) and renders
% the points as a coloured 3D scatter plot.

% Use opengl for rendering, as it can use graphics hardware.
set(0,'DefaultFigureRenderer','opengl')

% Use given figure or create a new one.
if nargin < 2
    figHandle = figure();
end
figure(figHandle)

% set colourmap
colormap(gca,rgbd_points(:,4:6)/255);
% unit^2 area per point to plot
markerSize = 9;
S = ones(length(rgbd_points),1) * markerSize;
% scatter plot our coloured point cloud
scatter3(rgbd_points(:,1),rgbd_points(:,2),rgbd_points(:,3),S(:),1:length(rgbd_points),'filled');

end