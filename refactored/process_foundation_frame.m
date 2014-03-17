function [foundationFrameEdges, composite_3d_points] = process_foundation_frame(foundation_frame)
% Extracts the 3D edges from the foundation frame for later use in ICP
% alignment.

foundation_box_mask = get_box_mask(foundation_frame);

foundation_edges_mask = get_box_edges(foundation_frame, ...
    foundation_box_mask);

foundationFrameEdges = get_point_list(foundation_frame, foundation_edges_mask);

foundation_box_3d_points = get_point_list(foundation_frame, foundation_box_mask);
composite_3d_points = foundation_box_3d_points;

end