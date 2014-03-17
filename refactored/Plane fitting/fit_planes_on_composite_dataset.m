function [ Planes, Angle ] = fit_planes_on_composite_dataset( composite_3d_points )
%Given all dataset fit planes on it and return plane equations with angle
%between them

depth_points = composite_3d_points(1:3,:)';

[Planes, ~ ] = plane_kmeans(depth_points, 2, 10, 300 );

a = Planes(:, 1);
b = Planes(:, 2);

costheta = dot(a,b) / (norm(a)*norm(b));
Angle = acos(costheta);
Angle = radtodeg(Angle);

if Angle > 90,
    Angle = 180 - Angle;
end

end

