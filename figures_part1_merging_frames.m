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
    
    save_figure_bin_depth_points(composite_3d_points,  'part1', i );
    save_figure_bin_rgb_depth_points(composite_3d_points, 'part1c', i);
end


