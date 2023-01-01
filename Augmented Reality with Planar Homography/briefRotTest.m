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
    

    %% Match features
    [locs1, locs2] = matchPics(im, r_im);
    
    %% Update histogram
    numMatches = size(locs1, 1);
    countMatches(i+1) = numMatches;
    
    if((i * 10 == 30) || (i * 10 == 90) || (i * 10 == 120))
        rot_fig = figure; 
        showMatchedFeatures(im,r_im,locs1,locs2, 'montage');
        legend("matched points 1","matched points 2");
        title(sprintf("BRIEF matches at %d orientation", i * 10));
        frame = getframe(rot_fig);
        imwrite(frame2im(frame), sprintf("../results/Q4_2-Brief_%d_orientation.png", i * 10));
    end
end

%% Display histogram
hist_fig = figure;
histogram(countMatches, "NumBins", 50);
xlabel("Number of matches");
ylabel("Frequency (Number of rotations)")
title("Histogram of Number of matches using BRIEF descriptor");
frame = getframe(hist_fig);
imwrite(frame2im(frame), "../results/Q4_2-Brief_Histogram.png");

%% Display bar graph for comparison
figure;
X = (0:10:360);
Y = countMatches;
bar(X, Y);
xlabel("Rotated angle");
ylabel("Number of matches");
title("Bar graph BRIEF descriptor: Number of matches per rotation");