function evaluationFigure1depth(frame,  prefix, number )
% produces images for just the range points showing both the frontal view and also the top view of the box

T = frame(1:3, :)';

h =  figure('Visible','Off');
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 90)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_side_depth_image'), 'bmp');


h =  figure('Visible','Off');
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 0)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_top_depth_image'), 'bmp');
end

