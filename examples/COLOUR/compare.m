function compare

%% Compare 2 RGB colour images by computing comparison measures
%% on their colour histogram distributions using euclidean, 
%% chi-squared and BHATTACHARYYA distances
%%
%% function will prompt for images and print out comparison measures
%%
%% Author / Copyright: T. Breckon, March 2006.
%% School of Informatics, University of Edinburgh.
%% License: http://www.gnu.org/licenses/gpl.txt

%% get image names

image1name = input('Enter first image file name\n?','s');
image2name = input('Enter second image file name\n?','s');

%% load images

image1 = imread(image1name);
image2 = imread(image2name);

%% compute normalised histograms

[r1, g1, b1] = rgbhist(image1,0,1);
[r2, g2, b2] = rgbhist(image2,0,1);

%% concat 3 channels into single histograms

hist1 = [r1' g1' b1'];
hist2 = [r2' g2' b2'];

%% normalise as 3 histograms have now been combined

hist1 = hist1 / 3;
hist2 = hist2 / 3;

%% compute comparison statistics

bhattacharyyaDistance = bhattacharyya(hist1, hist2)
chiSquaredDistance = histogram_chisquare(hist1, hist2)
    
EuclideanVec = (hist1 - hist2);     %% N.B. squared diffs. would be better
EuclideanDistance = sqrt(EuclideanVec * EuclideanVec')

%% plot images and RGB histograms

axisYmax = max(max(r1), max(max(g1), max(b1)));
axisYmax = max(axisYmax, max(max(r2), max(max(g2), max(b2))));

figure(1);
set(1, 'Name', 'RGB Histogram Comparison');
subplot(2, 2, 1);
imshow(image1);
xlabel('RGB Image 1');

subplot(2, 2, 2);
hold on
plot(r1, 'red')
plot(g1, 'green')
plot(b1, 'blue')
axis([0, 256, 0, axisYmax])
xlabel('RGB Image 1 - normalised RGB histogram');

subplot(2, 2, 3);
imshow(image2);
xlabel('RGB Image 2');

subplot(2, 2, 4);
hold on
plot(r2, 'red')
plot(g2, 'green')
plot(b2, 'blue')
axis([0, 256, 0, axisYmax])
xlabel('RGB Image 2 - normalised RGB histogram');
