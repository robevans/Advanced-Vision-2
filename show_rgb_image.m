function [ output_args ] = show_rgb_image( frame1 , figure_rgb)
%SHOW_RG_IMAGE Summary of this function goes here
%   Detailed explanation goes here


figure(figure_rgb);
imshow(frame1(:,:,4:6)/255)

end

