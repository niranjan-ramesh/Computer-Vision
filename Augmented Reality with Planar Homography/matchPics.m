function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if(size(I1, 3) == 3)
    I1 = rgb2gray(I1);
end
if(size(I2, 3) == 3)
    I2 = rgb2gray(I2);
end
    
%% Detect features in both images
points_1 = detectFASTFeatures(I1);
points_2 = detectFASTFeatures(I2);

%% Obtain descriptors for the computed feature locations

[desc_p1, locs_p1] = computeBrief(I1, points_1.Location);
[desc_p2, locs_p2] = computeBrief(I2, points_2.Location);

%% Match features using the descriptors
indexPairs = matchFeatures(desc_p1, desc_p2, 'MatchThreshold', 10.0, "MaxRatio", 0.7);

locs1 = locs_p1(indexPairs(:,1),:);
locs2 = locs_p2(indexPairs(:,2),:);


end

