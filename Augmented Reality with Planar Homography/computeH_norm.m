function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid
x1 = x1 - centroid1;
x2 = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
dist1 = sqrt((x1(:, 1) .^ 2) + (x1(:, 2) .^ 2));
dist2 = sqrt((x2(:, 1) .^ 2) + (x2(:, 2) .^ 2));

scale1 = sqrt(2) / mean(dist1);
scale2 = sqrt(2) / mean(dist2);

shiftx1 = -centroid1(1) * scale1;
shifty1 = -centroid1(2) * scale1;
shiftx2 = -centroid2(1) * scale2;
shifty2 = -centroid2(2) * scale2;

x1 = x1 * scale1;
x2 = x2 * scale2;

%% similarity transform 1
T1 = [scale1,      0, shiftx1;
           0, scale1, shifty1;
           0,      0,       1];

%% similarity transform 2
T2 = [scale2,      0, shiftx2;
           0, scale2, shifty2;
           0,      0,       1];

%% Compute Homography
H2to1 = computeH(x1, x2);

%% Denormalization
% H2to1 = inv(T1) * H2to1 * T2;
% Since matlab asked to use \ instead of inv
H2to1 = T1 \ H2to1 * T2;
