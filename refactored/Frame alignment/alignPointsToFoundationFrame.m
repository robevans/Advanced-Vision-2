function composite_3d_points = alignPointsToFoundationFrame(frame, foundationFrameEdgePoints, composite_3d_points)
% Aligns two sets of points using edges extracted from the RGB images.

% Run an edge detector on the extracted box
box_mask = get_box_mask(frame);
edges_mask = get_box_edges(frame, box_mask);

% Get the 3D points registered to the RGB edge points
edge_point_list = get_point_list(frame, edges_mask);
box_3d_points = get_point_list(frame, box_mask);

% Estimate the transformation between the box in the current frame and the foundation frame.
[TR, TT] = icp(foundationFrameEdgePoints(1:3,:), edge_point_list(1:3,:), 100, 'Matching', 'kDtree');

% Apply transformation to register box points to the foundation frame.
box_3d_points(1:3,:) = TR * box_3d_points(1:3,:) + repmat(TT, 1, length(box_3d_points(1:3,:)));

% Add the transformed points to the set of points from all frames.
composite_3d_points = [composite_3d_points box_3d_points];

end