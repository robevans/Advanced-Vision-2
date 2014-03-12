clearvars, close all
load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

foundation_frame_index = floor(length(frames) / 2);
foundation_frame = frames{foundation_frame_index};

composite_3d_points = foundation_frame(:, :, 1:3);

foundation_box_mask = get_box_mask(foundation_frame);

foundation_edges_mask = get_box_edges(foundation_frame, ...
    foundation_box_mask);

foundation_edge_point_list = get_point_list(foundation_frame, foundation_edges_mask);

composite_3d_points = get_point_list(foundation_frame, foundation_box_mask);

for i=1:20
    if i == foundation_frame_index,
        continue
    end

% Load image
frame = frames{i};

box_mask = get_box_mask(frame);

edges_mask = get_box_edges(frame, box_mask);

edge_point_list = get_point_list(frame, edges_mask);

[TR, TT] = icp(foundation_edge_point_list, edge_point_list, 100, 'Matching', 'kDtree');

box_3d_points = get_point_list(frame, box_mask);

transformed_box_3d_points ...
 = TR * box_3d_points + repmat(TT, 1, length(box_3d_points));

composite_3d_points = [composite_3d_points transformed_box_3d_points];

T = composite_3d_points';

figure(1)
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);

pause;

end