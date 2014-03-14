function [  ] = plot_plane( normal, range, figure_handle )
%PLOT_PLANE Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    range =   [-10, 10];
end

if nargin < 3
    figure_handle = gcf;
end

min_val = range(1);
max_val = range(2);

[xx, yy]= ndgrid(min_val:0.1:max_val, min_val:0.1:max_val);

d = normal(4);

% calculate corresponding z
z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);

% plot the surface
figure(figure_handle)
surf(xx, yy, z)

xlabel('x')
ylabel('y')
zlabel('z')


end

