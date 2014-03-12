function [ rgb_images_edges ] = get_box_edges( frame, mask )
%GET_BOX_EDGES Given mask, it extracts edges for a box

rgb_frame = frame(:,:,4:6)/255;
masked_rgb_image = repmat(mask, 1, 1, 3) .* rgb_frame;

I = rgb2gray(masked_rgb_image);
rgb_images_edges = edge(I, 'canny',[0.1 0.2],4);

end

