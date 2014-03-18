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

box_mask = get_box_mask(frame);

edges_mask = get_box_edges(frame, box_mask);

edge_point_list = get_point_list(frame, edges_mask);
box_3d_points = get_point_list(frame, box_mask);

[TRe, TTe] = icp(foundation_edge_point_list(1:3, :), edge_point_list(1:3, :), 100, 'Matching', 'kDtree');
[TRf, TTf] = icp(foundation_box_3d_points(1:3, :), box_3d_points(1:3, :), 100, 'Matching', 'kDtree');

%TRf = TRe;
%TTf = TTe;

TR = (TRf + TRe*10) / 11;
TT = (TTf + TTe*10) / 11;


transformed_box_3d_points ...
 = TR * box_3d_points(1:3, :) + repmat(TT, 1, length(box_3d_points));

%composite_3d_points = [composite_3d_points transformed_box_3d_points];

T = box_3d_points';
Q = transformed_box_3d_points';
O = foundation_box_3d_points(1:3, :)';
figure(1)
hold on;
plot3(O(:,1), O(:,2), O(:,3), 'r.', 'MarkerSize', 0.5);
plot3(T(:,1), T(:,2), T(:,3), 'b.', 'MarkerSize', 0.5);
plot3(Q(:,1), Q(:,2), Q(:,3), 'g.', 'MarkerSize', 0.5);


end