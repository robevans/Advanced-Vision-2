function [ output_args ] = show_rgb_image( frame1 )
%SHOW_RG_IMAGE Summary of this function goes here
%   Detailed explanation goes here


figure;
imshow(frame1(:,:,4:6)/255)

end

