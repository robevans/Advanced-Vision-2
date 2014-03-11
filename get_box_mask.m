function [ final_box_mask ] = get_box_mask( frame )
%GET_BOX_MASK Summary of this function goes here
%   Detailed explanation goes here


% Convert to chromaticity

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

% Find two large objects in the mask (the orange parts of the box)
stats = regionprops(rgbdMask,'Area','PixelIdxList', 'PixelList','Centroid');
[~, sortedAreaIndexes] = sort([stats.Area], 'descend');

% Find the region lowest in the image (the bottom of the box).
if stats(sortedAreaIndexes(1)).Centroid(2) >= stats(sortedAreaIndexes(2)).Centroid(2)
    box_base = sortedAreaIndexes(1);
else
    box_base = sortedAreaIndexes(2);
end

% Apply combined thresholds to the image

im_box_bottom = zeros( size(rgbdMask) );
im_box_bottom( stats(box_base).PixelIdxList ) = 1;

[row_size, col_size] = size(im_box_bottom);
row_numbers = (1:row_size)';

row_numbered_matrix = repmat(row_numbers, 1, col_size);

row_numbered_matrix = row_numbered_matrix .* im_box_bottom;
bottom_rows = max(row_numbered_matrix);



for i=1:col_size,
    row = bottom_rows(i);
    
    if row > 0,
        im_box_bottom(1:row, i) = 1;
    end
end

final_box_mask = im_box_bottom & depthMask;

end

