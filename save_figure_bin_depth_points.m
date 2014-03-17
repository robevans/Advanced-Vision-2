
function [ output_args ] = save_figure_bin_depth_points(frame,  prefix, number )


T = frame(1:3, :)';

h =  figure('Visible','Off');
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 90)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_depth_image_side'), 'png');


h =  figure('Visible','Off');
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);
view(0, 0)
axis('tight');
axis off;
saveas(h, strcat('figures/', prefix,'_', int2str(number), '_depth_image_top'), 'png');
end

