function evaluationFigure1_range(frame,  prefix, number )
% Produces images for just the range points showing both the frontal view
% and also the top view of the box.

depth_frame = frame(1:3, :)';

% Plot side view of box
h = figure('Visible','On');
plot3(depth_frame(:,1), depth_frame(:,2), depth_frame(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 90)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_side'), 'bmp');

% Plot top view of box
h = figure('Visible','On');
plot3(depth_frame(:,1), depth_frame(:,2), depth_frame(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 0)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_top'), 'bmp');
end

