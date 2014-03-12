clearvars, close all
load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

foundation_frame_index = floor(length(frames) / 2);
foundation_frame = frames{foundation_frame_index};

foundation_frame_mask = get_box_mask(foundation_frame);

foundation_frame_edges = get_box_edges(foundation_frame, ...
    foundation_frame_mask);

foundation_edge_depth_points ...
    = foundation_frame(:, :, 1:3) .* repmat(foundation_frame_edges, 1, 1, 3);

foundation_edge_point_list ...
    = reshape(foundation_edge_depth_points(:, :, 1:3), 3, 640*480);

for i=1:20

% Load image
frame = frames{i};

mask = get_box_mask(frame);

edge_2d_points = get_box_edges(frame, mask);

edge_3d_points ...
    = frame(:, :, 1:3) .* repmat(edge_2d_points, 1, 1, 3);
edge_point_list ...
    = reshape(edge_3d_points(:, :, 1:3), 3, 640*480);


[TR, TT] = icp(foundation_edge_point_list, edge_point_list);

pause;

end