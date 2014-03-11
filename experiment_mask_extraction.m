clearvars, close all
load kinect_recyclebox_20frames
frames = kinect_recyclebox_20frames;

for i=1:20

% Load image
frame = frames{i};
rgb_frame = frame(:,:,4:6)/255;

% Convert to chromaticity
mask = get_box_mask(frame);
figure(1)
imshow(mask)

figure(2);
imshow(repmat(mask, 1, 1, 3) .* rgb_frame); 


pause

%{
frame_ch = convertToChromaticity(frame(:,:,4:6));
imshow(frame(:,:,4:6)/255); % rgb image
show_depth_image(frame, 4); % depth image
figure(5)
im_box_bottom = zeros( size(rgbdMask) );
im_box_bottom( stats(box_base).PixelIdxList ) = 1;
imshow(im_box_bottom) % detected base of box (orange region)

% Display isolated regions
figure(1)
imshow(chr_masked_image)
pause
%}

end