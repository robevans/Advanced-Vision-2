function evaluationFigure2(frame,  prefix, number )
% Produces zoomed colour images of the left white square after each dataset
% is merged.

rgbd_points = frame';
set(0,'DefaultFigureRenderer','opengl')

% Display the coloured point cloud
markerSize = 9;
S = ones(length(rgbd_points),1) * markerSize;
fh = createfigure(rgbd_points(:,1),rgbd_points(:,2),rgbd_points(:,3),S(:),1:length(rgbd_points), rgbd_points(:,4:6)/255);

% Save image
saveas(fh, strcat('figures/', prefix,'_', int2str(number), '_left_square'), 'bmp');
end

function figHandle = createfigure(X1, Y1, Z1, S1, C1, CM)
% Create figure
figHandle = figure('Renderer','OpenGL',...
    'Colormap',CM,'Visible','On');
% Create axes
axes1 = axes('Visible','off','Parent',figHandle);
% Preserve the XYZ-limits of the axes to show just the left white square.
xlim(axes1,[-0.0730201348505626 -0.00484057877780553]);
ylim(axes1,[-0.0651544747530056 0.0222683151118335]);
zlim(axes1,[-2.07067570086709 -1.6567103900871]);

grid(axes1,'on');
hold(axes1,'all');

% Create scatter3
scatter3(X1,Y1,Z1,S1,C1,'MarkerFaceColor','flat','MarkerEdgeColor','none');

end