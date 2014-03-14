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

[TRe, TTe] = icp(foundation_edge_point_list, edge_point_list, 100, 'Matching', 'kDtree');
%[TRf, TTf] = icp(foundation_box_3d_points, box_3d_points, 100, 'Matching', 'kDtree');

TRf = TRe;
TTf = TTe;

TR = (TRf + TRe*10) / 11;
TT = (TTf + TTe*10) / 11;

transformed_box_3d_points ...
 = TR * box_3d_points + repmat(TT, 1, length(box_3d_points));

composite_3d_points = [composite_3d_points transformed_box_3d_points];

%T = composite_3d_points';

end

points = composite_3d_points';
[Planes, Assignments ] = plane_kmeans(points, 2, 10 );

%range = [min(min(points(:,1:2))) max(max(points(:,1:2)))]
range = [-0.5 0.5];

first_plane_points = points(Assignments == 1, :);
second_plane_points = points(Assignments == 2, :);

range_first = [min(first_plane_points(:,1)) max(first_plane_points(:,1)) ...
               min(first_plane_points(:,2)) max(first_plane_points(:,2)) ];

range_second = [min(second_plane_points(:,1)) max(second_plane_points(:,1)) ...
               min(second_plane_points(:,2)) max(second_plane_points(:,2)) ];

plot_plane(Planes(:, 1), range_first); hold on; 
plot_plane(Planes(:, 2), range_second);
plot3(points(:,1), points(:,2), points(:,3), 'k.', 'MarkerSize', 0.1);
