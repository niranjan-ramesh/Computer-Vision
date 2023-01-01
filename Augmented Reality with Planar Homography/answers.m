rng('shuffle');

% 4.1 Feature Detection, Description and matching

img_1 = imread('../data/cv_desk.png');
img_2 = imread('../data/cv_cover.jpg');


[locs1, locs2] = matchPics(img_1, img_2);

matches_fig = figure;
showMatchedFeatures(img_1, img_2, locs1, locs2, 'montage');
title('Feature matches (FAST) using BRIEF descriptor');
frame = getframe(matches_fig);
imwrite(frame2im(frame), "../results/Q4_1-FeatureMatches.png")

% 4.3 Homography computation

rands = randperm(size(locs1, 1), 10);
H2to1 = computeH(locs1, locs2);

disp_locs1 = zeros(size(rands, 2), 2);
for i = 1:size(rands, 2)
    p = [locs2(rands(i), :)'; 1];
    p_prime = H2to1 * p;
    p_prime = p_prime([1,2]) / p_prime(3);
    disp_locs1(i, :) = p_prime';
end

hom_fig = figure;
disp_locs2 = locs2(rands, :);
showMatchedFeatures(img_1, img_2, disp_locs1, disp_locs2, 'montage');
title('ComputeH viz');
frame = getframe(hom_fig);
imwrite(frame2im(frame), "../results/Q4_3-Compute_H.png");



% 4.4 Homography Normalization

rands = randperm(size(locs1, 1), 10);
H2to1 = computeH_norm(locs1, locs2);

disp_locs1 = zeros(size(rands, 2), 2);
for i = 1:size(rands, 2)
    p = [locs2(rands(i), :)'; 1];
    p_prime = H2to1 * p;
    p_prime = p_prime([1,2]) / p_prime(3);
    disp_locs1(i, :) = p_prime';
end

norm_fig = figure;
disp_locs2 = locs2(rands, :);
showMatchedFeatures(img_1, img_2, disp_locs1, disp_locs2, 'montage');
title('ComputeH normalization viz');
frame = getframe(norm_fig);
imwrite(frame2im(frame), "../results/Q4_4-ComputeH_Norm.png");

% 4.5 RANSAC

[H2to1, inliers, idxs] = computeH_ransac(locs1, locs2);

%%% Display the inliers

rands = find(inliers == 1);
disp_locs1 = zeros(size(rands, 1), 2);

for i = 1:size(rands, 1)
    p = [locs2(rands(i), :)'; 1];
    p_prime = H2to1 * p;
    p_prime = p_prime([1,2]) / p_prime(3);
    disp_locs1(i, :) = p_prime';
end

inliers_fig = figure;
disp_locs2 = locs2(rands, :);
showMatchedFeatures(img_1, img_2, disp_locs1, disp_locs2, 'montage');
title('RANSAC viz Inliers');
frame = getframe(inliers_fig);
imwrite(frame2im(frame), "../results/Q4_5-Ransac_Inliers.png")

%%% Display the 4 best points

rands = idxs;
disp_locs1 = zeros(size(rands, 2), 2);
for i = 1:size(rands, 2)
    p = [locs2(rands(i), :)'; 1];
    p_prime = H2to1 * p;
    p_prime = p_prime([1,2]) / p_prime(3);
    disp_locs1(i, :) = p_prime';
end

points_fig = figure;
disp_locs2 = locs2(rands, :);
showMatchedFeatures(img_1, img_2, disp_locs1, disp_locs2, 'montage');
title('RANSAC viz of 4 best points');
frame = getframe(points_fig);
imwrite(frame2im(frame), "../results/Q4_5-Ransac_BestPoints.png")


