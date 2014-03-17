%clearvars, close all
%load kinect_recyclebox_20frames
frames = kinect_recyclebox_20frames;

% Extract information from foundation frame
[foundationFrameEdges, composite_3d_points] = process_foundation_frame( frames{floor( length(frames)/2 )} );

for i=1:20
    
    % Load image
    frame = frames{i};
    
    % Extract bin
    bin_mask = get_box_mask( frame ); 
    bin_points = repmat(bin_mask, 1, 1, 6) .* frame;
    
    % Align bin points from current frame with foundation frame
    composite_3d_points = alignPointsToFoundationFrame(frame, foundationFrameEdges, composite_3d_points);
    
    % Display demonstration images and pause
    figure(1)
    imshow( frame(:,:,4:6)/255 ) % original rgb image
    figure(2)
    imshow( uint8(bin_points(:,:,4:6)) ) % bin 2D points
    figure(3)
    show_scatter_image( bin_points, 3 ) % bin 3D points
    figure(4)
    display_textured_scatter_plot(composite_3d_points', 4); % Coloured 3D bin points from all frames
    
    pause
end