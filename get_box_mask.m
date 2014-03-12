function [ whole_box_mask ] = get_box_mask( frame )
%GET_BOX_MASK Extracts mask for box region from the image

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
[~,sortedAreaIndexes] = sort([stats.Area], 'descend');

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

end

