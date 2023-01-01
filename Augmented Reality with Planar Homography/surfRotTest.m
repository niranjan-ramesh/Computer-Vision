% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary

im = imread("../data/cv_cover.jpg");

if(size(im, 3) == 3)
    im = rgb2gray(im);
end

countMatches = zeros(37, 1);

%% Compute the features and descriptors

for i = 0:36
    %% Rotate image
    r_im = imrotate(im, 10 * i);

    %% Compute features and descriptors
    points1 = detectSURFFeatures(im);
    points2 = detectSURFFeatures(r_im);

    [features1,valid_points1] = extractFeatures(im,points1, 'Method', 'SURF');
    [features2,valid_points2] = extractFeatures(r_im,points2, 'Method','SURF');

    %% Match features
    indexPairs = matchFeatures(features1,features2, "MaxRatio", 0.7);
    locs1 = valid_points1(indexPairs(:,1),:);
    locs2 = valid_points2(indexPairs(:,2),:);
    
    %% Update histogram
    numMatches = size(locs1, 1);
    countMatches(i+1) = numMatches;

    if((i * 10 == 30) || (i * 10 == 60) || (i * 10 == 120))
        rot_fig = figure; 
        showMatchedFeatures(im,r_im,locs1,locs2, 'montage');
        legend("matched points 1","matched points 2");
        title(sprintf("SURF matches at %d orientation", i * 10));
        frame = getframe(rot_fig);
        imwrite(frame2im(frame), sprintf("../results/Q4_2-SURF_%d_orientation.png", i * 10));
    end
end

%% Display histogram
hist_fig = figure;
histogram(countMatches, "NumBins", 50);
xlabel("Number of matches");
ylabel("Frequency (Number of rotations)")
ylim([0, 8])
title("Histogram of Number of matches using SURF descriptor");
frame = getframe(hist_fig);
imwrite(frame2im(frame), "../results/Q4_2-SURF_Histogram.png");

%% Display bar graph for comparison
figure;
X = (0:10:360);
Y = countMatches;
bar(X, Y);
xlabel("Rotated angle");
ylabel("Number of matches");
title("Bar graph SURF descriptor: Number of matches per rotation");