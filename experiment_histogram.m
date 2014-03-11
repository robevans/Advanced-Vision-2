clearvars, close all
load kinect_recyclebox_20frames
frames = kinect_recyclebox_20frames;

for i=1:20

% Load image
frame = frames{i};

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

% Combine depth and chromaticity masks
rgbdMask = rgbChMask & depthMask;

% Apply combined thresholds to the image
chr_masked_image = repmat(rgbdMask, 1, 1, 3) .* frame_ch(:,:,1:3);

% Display handy images to help with development
figure(2)
imshow(frame_ch(:,:,1:3)); % chromaticity image
figure(3)
imshow(frame(:,:,4:6)/255); % rgb image
show_depth_image(frame, 4); % depth image

% Display isolated regions
figure(1)
imshow(chr_masked_image)
pause

end