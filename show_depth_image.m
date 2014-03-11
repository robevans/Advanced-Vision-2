function [ output_args ] = show_depth_image( frame1, figure_handle )
%SHOW_DEPTH_IMAGE Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    figure_handle = figure();
end

xyzrgb = frame1;

%xyz = reshape(xyzrgb(:, :, 1:3), 640*480, 3);
%xyzc = xyz(~any(isnan(xyz), 2), :);

frgb = zeros(480, 640, 3);
for r = 1 : 480
for c = 1 : 640
    if ~isnan(xyzrgb(r, c, 2))
        frgb(r,c,:) = xyzrgb(r, c, 1:3);
    end
end
end

mn = min(min(min(frgb)));
mx = max(max(max(frgb)));

figure(figure_handle);
imagesc((frgb-mn)/(mx-mn));


end

