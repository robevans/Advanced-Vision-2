function threeHists( image )
figure
a = subplot(3,1,1);
imhist(image(:,:,1))
b = subplot(3,1,2);
imhist(image(:,:,2))
c = subplot(3,1,3);
imhist(image(:,:,3))
linkaxes([a,b,c])
end

