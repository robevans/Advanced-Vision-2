function show_depth_image( frame1, figHandle )
%SHOW_DEPTH_IMAGE shows a false colour depth image.

if nargin < 2
    figHandle = figure;
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

figure(figHandle);
imagesc((frgb-mn)/(mx-mn));

end

