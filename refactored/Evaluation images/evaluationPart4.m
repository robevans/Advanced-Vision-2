% 1) After each merging, creates a bounding box around the rightmost merged white S and square.
% 2) Extracts the 3D points from that merged set.
% 3) Fits a plane to the point set.
% 4) Computes the average absolute value of the distance of each datapoint from that plane.
% 5) Plots these average distances as a function of the number of planes added.

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

plane_fitting_absolute_mean_error = [];

%include foundation frame in the error plot
[~, fit_error ] = fit_plane_to_s_box( composite_3d_points );
plane_fitting_absolute_mean_error(end + 1) = fit_error;

for i=1:20
    if i == foundation_frame_index,
        continue
    end
    
    % Load image
    frame = frames{i};
    
    % Extract bin
    bin_mask = get_box_mask( frame );
    bin_points = repmat(bin_mask, 1, 1, 6) .* frame;
    
    % Align bin points from current frame with foundation frame
    composite_3d_points = alignPointsToFoundationFrame(frame, foundationFrameEdges, composite_3d_points);
    
    % Fit plane to right frame
    [P, fit_error ] = fit_plane_to_s_box( composite_3d_points );
    
    % Store the plane fitting error for this frame
    plane_fitting_absolute_mean_error(end + 1) = fit_error;

end

plot(plane_fitting_absolute_mean_error);

