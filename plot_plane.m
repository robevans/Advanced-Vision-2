function [  ] = plot_plane( normal, range, figure_handle )
%PLOT_PLANE plots the plane with the given normal in 3D space.
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

step = 0.01;

[xx, yy]= ndgrid(x_min_val:step:x_max_val, y_min_val:step:y_max_val);

d = normal(4);

% calculate corresponding z
z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);

% plot the surface
figure(figure_handle)
surf(xx, yy, z,'LineStyle','none')

xlabel('x')
ylabel('y')
zlabel('z')

end

