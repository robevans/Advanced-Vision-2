clearvars

load kinect_recyclebox_20frames

frames = kinect_recyclebox_20frames;

for i=1:20

% Load and normalise
frame = frames{i};
frame_rgb = frame(:,:,4:6)/255;
frame_ch = convertToChromaticity(frame(:,:,4:6));

% Smooth images
gaussianFilter = fspecial('gaussian',[5 5],2);
frame_rgb = imfilter(frame_rgb, gaussianFilter, 'same');
frame_ch = imfilter(frame_ch, gaussianFilter, 'same');

figure(1)
imshow(frame_ch(:,:,1:3));

%{
rFrame = frame1_rgb(:,:,1);
gFrame = frame1_rgb(:,:,2);
bFrame = frame1_rgb(:,:,3);
%}

rChFrame = frame_ch(:,:,1);
gChFrame = frame_ch(:,:,2);
bChFrame = frame_ch(:,:,3);

%{
rMask = rFrame > 0.5 & rFrame < 0.72;
gMask = gFrame > 0.18 & gFrame < 0.37;
bMask = bFrame > 0.07 & bFrame < 0.32;
%}

rChMask = rChFrame > 0.43 & rChFrame < 0.69;
gChMask = gChFrame > 0.24 & gChFrame < 0.33;
bChMask = bChFrame > 0.06 & bChFrame < 0.28;

%rgbIntersectionMask = rMask & gMask & bMask;
chrIntersectionMask = rChMask & gChMask & bChMask;

%rgb_masked_image = repmat(rgbIntersectionMask, 1, 1, 3) .* frame1_rgb;

chr_masked_image = repmat(chrIntersectionMask, 1, 1, 3) .* frame_ch(:,:,1:3);

figure(2)
imshow(chr_masked_image)

pause
end