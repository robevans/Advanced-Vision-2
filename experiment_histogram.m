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
rChMask = frame_ch(:,:,1) > 0.43 & frame_ch(:,:,1) < 0.69;
gChMask = frame_ch(:,:,2) > 0.24 & frame_ch(:,:,2) < 0.33;
bChMask = frame_ch(:,:,3) > 0.06 & frame_ch(:,:,3) < 0.28;
rgbChMask = rChMask & gChMask & bChMask;

% Find the depth image values that are not nans.
depthMask = ~isnan(frame(:,:,1)) & ~isnan(frame(:,:,2)) & ~isnan(frame(:,:,3));

% Combine depth and chromaticity masks
rgbdMask = rgbChMask & depthMask;

% Apply combined thresholds to the image
chr_masked_image = repmat(rgbdMask, 1, 1, 3) .* frame_ch(:,:,1:3);

% Display isolated regions
imshow(chr_masked_image)
pause

end