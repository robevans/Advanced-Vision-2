clearvars, close all
load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

foundation_frame_index = floor(length(frames) / 2);
foundation_frame = frames{foundation_frame_index};

foundation_box_mask = get_box_mask(foundation_frame);

foundation_edges_mask = get_box_edges(foundation_frame, ...
    foundation_box_mask);

foundation_edge_point_list = get_edge_point_list(foundation_frame, foundation_edges_mask);

for i=1:20

% Load image
frame = frames{i};

box_mask = get_box_mask(frame);

edges_mask = get_box_edges(frame, box_mask);

edge_point_list = get_edge_point_list(frame, edges_mask);

tic
[TR, TT] = icp(foundation_edge_point_list, edge_point_list, 100, 'Matching', 'kDtree');
toc

Q = foundation_edge_point_list';
T = (TR * edge_point_list + repmat(TT, 1, length(edge_point_list)))';

figure(1)
hold on
plot3(Q(:,1), Q(:,2), Q(:,3), 'k.', 'MarkerSize', 10);
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 10);
hold off

pause;

end