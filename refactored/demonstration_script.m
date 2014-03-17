clearvars, close all
%% MAIN SCRIPT TO RUN ASSIGNMENT
% Set parameters below to show demo or evaluation images. (Showing both at
% once is not recommended)
show_demo_images = 1;
save_evaluation_images = 0;

% Load data frames
load kinect_recyclebox_20frames
frames = kinect_recyclebox_20frames;

% Extract information from foundation frame
[foundationFrameEdges, composite_3d_points] = process_foundation_frame( frames{floor( length(frames)/2 )} );

if save_evaluation_images
    evaluationPart1_range(composite_3d_points,  'part1_range', 0);
    evaluationPart1_colour(composite_3d_points, 'part1_color', 0);
    evaluationPart2(composite_3d_points, 'part2', 0);
end

for i=1:20
    
    % Load image
    frame = frames{i};
    
    % Extract bin
    bin_mask = get_box_mask( frame );
    bin_points = repmat(bin_mask, 1, 1, 6) .* frame;
    
    % Align bin points from current frame with foundation frame
    composite_3d_points = alignPointsToFoundationFrame(frame, foundationFrameEdges, composite_3d_points);
    
    if show_demo_images
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
    
    if save_evaluation_images
        evaluationPart1_range(composite_3d_points,  'part1_range', i );
        evaluationPart1_colour(composite_3d_points, 'part1_color', i);
        evaluationPart2(composite_3d_points, 'part2', i);
    end
    
end

if save_evaluation_images
    evaluationPart3;
    evaluationPart4;
end

[ ~, Angle] = fit_planes_on_composite_dataset( composite_3d_points );
fprintf('Angle between two planes: %f\n', Angle);