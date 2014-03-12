function edge_point_list = get_point_list(frame, edges_2d_mask)
%GET_POINT_LIST masks the depth frame and returns the list of points,
%removing any nans and (0,0,0) points.

frame_depth = frame(:, :, 1:3);

frame_masked_to_show_edges = frame_depth .* repmat(edges_2d_mask, 1, 1, 3);

% Remove nans and points that are (0,0,0)
edge_point_list = reshape(frame_masked_to_show_edges(:, :, 1:3), 640*480, 3);
edge_point_list_no_nans = edge_point_list(~any(isnan(edge_point_list), 2), :);
edge_point_list_no_zeros = edge_point_list_no_nans(any(edge_point_list_no_nans, 2), :);

edge_point_list = edge_point_list_no_zeros';

end