function [P, fit_error ] = fit_plane_to_s_box( composite_3d_points )
%FIT_PLANE_TO_S_BOX fits plane to s box and returns error

%select points that match rightmost "S." region
x = composite_3d_points(1, :)';
y = composite_3d_points(2, :)';
z = composite_3d_points(3, :)';
xc = 0.038 < x & x < 0.2403;
yc = -0.0679 < y & y < 0.1674;
zc = -2.1 < z & z < -1.5;
ic = xc & yc & zc;
filtered_points = [x(ic), y(ic), z(ic), composite_3d_points(4:6, ic)'];


filtered_depth_points = filtered_points(:, 1:3);
[P, ~] = fitplane(filtered_depth_points);

%dot product
absolute_distances  = abs(filtered_depth_points * P(1:3) + repmat(P(4), length(filtered_depth_points), 1));

fit_error = mean(absolute_distances);

end

