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
    
    % Add the transformed points to the set of points from all frames.
    composite_3d_points = [composite_3d_points box_3d_points];
    
end

% Fit two planes to the composite set of points from all frames.
depth_points = composite_3d_points(1:3,:)';
[Planes, Assignments ] = plane_kmeans(depth_points, 2, 10 );

first_plane_points = composite_3d_points(:, Assignments == 1);
second_plane_points = composite_3d_points(:, Assignments == 2);

% Only plot the part of the plane that covers the data (it's an infinite
% plane)
range_first = [min(first_plane_points(1,:)) max(first_plane_points(1,:)) ...
    min(first_plane_points(2,:)) max(first_plane_points(2,:)) ];

range_second = [min(second_plane_points(1,:)) max(second_plane_points(1,:)) ...
    min(second_plane_points(2,:)) max(second_plane_points(2,:)) ];

display_textured_scatter_plot(composite_3d_points')

%{
plot_plane(Planes(:, 1), range_first); hold on;
plot_plane(Planes(:, 2), range_second);
plot3(depth_points(:,1), depth_points(:,2), depth_points(:,3), 'k.', 'MarkerSize', 0.1);
    %}
