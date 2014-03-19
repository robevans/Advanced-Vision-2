clearvars, close all
load kinect_recyclebox_20frames
frames = kinect_recyclebox_20frames;

for i=1:20

% Load image
frame = frames{i};
frame_rgb = frame(:,:,4:6)/255;

% Convert to chromaticity
frame_ch = convertToChromaticity(frame(:,:,4:6));

% Smooth
gaussianFilter = fspecial('gaussian',[5 5],2);
frame_ch = imfilter(frame_ch, gaussianFilter, 'same');

% Threshold each chromaticity colour channel to detect orange regions.
rChMask = frame_ch(:,:,1) > 0.43 & frame_ch(:,:,1) < 0.71;
gChMask = frame_ch(:,:,2) > 0.21 & frame_ch(:,:,2) < 0.33;
bChMask = frame_ch(:,:,3) > 0.02 & frame_ch(:,:,3) < 0.28;
rgbChMask = rChMask & gChMask & bChMask;

% Find the depth image values that are not nans.
depthMask = ~isnan(frame(:,:,1)) & ~isnan(frame(:,:,2)) & ~isnan(frame(:,:,3));

% Intersect depth and chromaticity masks
rgbdMask = rgbChMask & depthMask;

% Find two large objects in the mask (the orange parts of the box)
stats = regionprops(rgbdMask,'Area','PixelIdxList','Centroid');
[sortedAreas,sortedAreaIndexes] = sort([stats.Area], 'descend');

% Find the region lowest in the image (the bottom of the box).
if stats(sortedAreaIndexes(1)).Centroid(2) >= stats(sortedAreaIndexes(2)).Centroid(2)
    box_base = sortedAreaIndexes(1);
else
    box_base = sortedAreaIndexes(2);
end
im_box_bottom = zeros( size(rgbdMask) );
im_box_bottom( stats(box_base).PixelIdxList ) = 1;

% Find the lower edge of the bottom region.
bottom_rows = max(repmat((1:480)', 1, 640) .* im_box_bottom);

% Find all depth values above the lower edge of the box.
im_region_above_box_bottom = zeros( size(rgbdMask) );
for col = 1:640,
    row = bottom_rows(col);
    if row > 0,
        im_region_above_box_bottom(1:row, col) = 1;
    end
end 
whole_box_mask = im_region_above_box_bottom & depthMask;


%Histogram thresholding to remove noise from edges of box.
detection_image = repmat(whole_box_mask, 1, 1, 3) .* frame_rgb;
detection_ch_image = repmat(whole_box_mask, 1, 1, 3) .* frame_ch(:,:,1:3);

% Threshold each colour channel to eliminate noise around the box.  (Better to use adaptive thresholding)
rMask = frame_ch(:,:,1) > 0.1 & frame_ch(:,:,1) < 0.79 & (frame_rgb(:,:,1) < 0.37 | frame_rgb(:,:,1) > 0.48);
gMask = frame_ch(:,:,2) > 0.06 & frame_ch(:,:,2) < 0.71;
bMask = frame_ch(:,:,3) > 0.01 & frame_ch(:,:,3) < 0.7;
noise_removal_mask = rMask & gMask & bMask & whole_box_mask;

% Fill the largest connected component (the box) to remove any holes


% Display handy images to help with development
figure(1)
imshow(frame_rgb); % rgb image
show_depth_image(frame, 2); % depth image
figure(3)
imshow(frame_ch(:,:,1:3)); % chromaticity image
figure(4)
imshow(repmat(rgbdMask, 1, 1, 3) .* frame_ch(:,:,1:3)); % Display isolated regions
figure(5)
imshow(im_box_bottom) % detected base of box (orange region)
figure(6)
imshow(repmat(whole_box_mask, 1, 1, 3) .* frame_ch(:,:,1:3)); % Detected box with edge noise
figure(7)
imshow(repmat(noise_removal_mask, 1, 1, 3) .* frame_ch(:,:,1:3)); % Detected box thresholded for noise
threeHists(detection_ch_image, 8)


end