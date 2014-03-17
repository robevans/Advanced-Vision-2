% Extracts the surface normal of each of the rightward facing planes from the 20 images. Invert
% if necessary to make sure that they are all facing towards the viewer. After applying
% the registration transformation to each, compute the angle between each vector and the
% ‘Foundation’ image’s vector. Reports the average and standard deviation of the angles.

clearvars, close all
load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

foundation_frame_index = floor(length(frames) / 2);
foundation_frame = frames{foundation_frame_index};

foundation_box_mask = get_box_mask(foundation_frame);

foundation_edges_mask = get_box_edges(foundation_frame, ...
    foundation_box_mask);

foundation_edge_point_list = get_point_list(foundation_frame, foundation_edges_mask);

foundation_box_3d_points = get_point_list(foundation_frame, foundation_box_mask);
composite_3d_points = foundation_box_3d_points;


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
    
    % Extract the box
    box_mask = get_box_mask(frame);
    
    % Run an edge detector on the extracted box
    edges_mask = get_box_edges(frame, box_mask);
    
    edge_point_list = get_point_list(frame, edges_mask);
    box_3d_points = get_point_list(frame, box_mask);
    
    % Estimate the transformation between the box in the current frame and the foundation frame.
    [TR, TT] = icp(foundation_edge_point_list(1:3,:), edge_point_list(1:3,:), 100, 'Matching', 'kDtree');
    
    % Apply transformation to register box points to the foundation frame.
    box_3d_points(1:3,:) = TR * box_3d_points(1:3,:) + repmat(TT, 1, length(box_3d_points(1:3,:)));
    
    
    composite_3d_points = box_3d_points;
    depth_points = composite_3d_points(1:3,:)';
    
    %depth_points = box_3d_points';
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
    
    
    
    %
    %hold on;
    %plot3(depth_points(:,1), depth_points(:,2), depth_points(:,3), 'k.', 'MarkerSize', 0.1);
    %plot_plane(Planes(:, chosen_plane), range(chosen_plane, :));
    %hold off;
    
    a = foundation_right_plane_normal;
    b = Planes(:, chosen_plane);
    costheta = dot(a,b)/(norm(a)*norm(b));
    theta = acos(costheta);
    
    angles = [angles ; costheta, theta ];
end

angles_degrees = radtodeg(angles(:, 2));
angles_degrees( angles_degrees > 90 ) =  180 - angles_degrees( angles_degrees > 90 );

% Output final results
evaluationPart3_average_angle = mean(angles_degrees)
evaluationPart3_std_angles = std(angles_degrees)


