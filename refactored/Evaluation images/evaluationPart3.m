% Extracts the surface normal of each of the rightward facing planes from the 20 images. Invert
% if necessary to make sure that they are all facing towards the viewer. After applying
% the registration transformation to each, compute the angle between each vector and the
% ‘Foundation’ image’s vector. Reports the average and standard deviation of the angles.

clearvars, close all
load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

% Extract information from foundation frame
[foundationFrameEdges, composite_3d_points] = process_foundation_frame( frames{floor( length(frames)/2 )} );

[Planes, Assignments ] = plane_kmeans(foundation_box_3d_points(1:3, :)', 2, 10, 200 );
first_plane_points = foundation_box_3d_points(:, Assignments == 1);
second_plane_points = foundation_box_3d_points(:, Assignments == 2);

if mean(first_plane_points(1, :)) > mean(second_plane_points(1, :))
    foundation_right_plane_normal = Planes(:, 1);
else 
    foundation_right_plane_normal = Planes(:, 2);
end

angles = [];

for i=1:20
    if i == foundation_frame_index,
        continue
    end
    
    % Load image
    frame = frames{i};
    
    % Extract bin
    bin_mask = get_box_mask( frame );
    bin_points = repmat(bin_mask, 1, 1, 6) .* frame;
    
    % Align bin points from current frame with foundation frame
    composite_3d_points = alignPointsToFoundationFrame(frame, foundationFrameEdges, composite_3d_points);
    
    depth_points = composite_3d_points(1:3,:)';
    
    [Planes, Assignments ] = plane_kmeans(depth_points, 2, 10, 300 );
    
    first_plane_points = composite_3d_points(:, Assignments == 1);
    second_plane_points = composite_3d_points(:, Assignments == 2);
    
    % Only plot the part of the plane that covers the data (it's an infinite
    % plane)
    range = zeros(2, 4);
    range(1, :) = [min(first_plane_points(1,:)) max(first_plane_points(1,:)) ...
        min(first_plane_points(2,:)) max(first_plane_points(2,:)) ];
    
    range(2, :) = [min(second_plane_points(1,:)) max(second_plane_points(1,:)) ...
        min(second_plane_points(2,:)) max(second_plane_points(2,:)) ];
    
    if mean(first_plane_points(1, :)) > mean(second_plane_points(1, :))
        chosen_plane = 1;
    else 
        chosen_plane = 2;
    end
    
    a = foundation_right_plane_normal;
    b = Planes(:, chosen_plane);
    costheta = dot(a,b)/(norm(a)*norm(b));
    theta = acos(costheta);
    
    angles = [angles ; costheta, theta ];
end

angles_degrees = radtodeg(angles(:, 2));
angles_degrees( angles_degrees > 90 ) =  180 - angles_degrees( angles_degrees > 90 );

angles_degrees;

% Output final results
evaluationPart3_average = mean(angles_degrees)
evaluationPart3_std = std(angles_degrees)


