
function show_scatter_image( frame, figHandle )
%SHOW_SCATTER_IMAGE Summary of this function goes here
%   Detailed explanation goes here

% Use given figure or create a new one.
if nargin < 2
    figHandle = figure();
end
figure(figHandle)

xyzrgb = frame;

xyz = reshape(xyzrgb(:, :, 1:3), 640*480, 3);
xyzc = xyz(~any(isnan(xyz), 2), :);
% make a list of (x,y,z) points
% remove any entries that have a NaN
plot3(xyzc(:,1), xyzc(:,2), xyzc(:,3), 'k.', 'MarkerSize', 0.1);
%If you want to see a false coloured depth image, use
%figure(3)

end
