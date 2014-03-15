function [  ] = plot_plane_colors( normal, range, points, figure_handle )
%PLOT_PLANE_COLORS Plotting planes with color information
if nargin < 2
    range =   [-10, 10, -10, 10];
end

if nargin < 3
    figure_handle = gcf;
end

x_min_val = range(1);
x_max_val = range(2);
y_min_val = range(3);
y_max_val = range(4);

%step = 0.003;
step = 0.005;

depth_points = points(:, 1:3);

[xx, yy]= ndgrid(x_min_val:step:x_max_val, y_min_val:step:y_max_val);

d = normal(4);

% calculate corresponding z as vector (for pairing)
z_vector = (-normal(1)*xx(:) - normal(2)*yy(:) - d)/normal(3);

% calculate corresponding z as matrix (for surf)
zz = (-normal(1)*xx - normal(2)*yy - d)/normal(3);

% sampled plane points for figure as (x, y, z) x N format
Y = [xx(:) yy(:) z_vector];

%matches between real points and sampled plane points
Assignments = zeros(length(points), 1);

%for each point calculate distance and assign for real
%point closest sampled point

%possible to use pdist2 but we get out of memory error
disp('Calculating distances');
for i = 1:length(depth_points),
    cm = depth_points(i, :);
    dist = abs(bsxfun(@minus, Y, cm));
    sm = sum(dist, 2);
    [~, I] = min(sm);
    Assignments(i) = I;
end

%color information for sampled points
colors = zeros(size(Y));

%for each sampled point calculated averaged color from
%assigned real points
disp('Calculating colors');
for i = 1:length(Y),
    entry_colors = points(Assignments == i, 4:6);
    color_mean = mean(entry_colors);
    colors(i, :) = color_mean;
end

%normalise data
colors(isnan(colors)) = 0;
colors = colors / 255;

%reshape in format that surf will accept
C = reshape(colors, [size(xx, 1) size(yy, 2) 3]);

% plot the surface
figure(figure_handle)
surf(xx, yy, zz, C,'EdgeColor','none','LineStyle','none')

xlabel('x')
ylabel('y')
zlabel('z')

end

