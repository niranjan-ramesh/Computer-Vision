function [ bestH2to1, inliers, idxs] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
threshold = 1;

bestH2to1 = [];
inliers = [];
idxs = [];

max_inliers = 0;

for iters = 1:2500
    rands = randperm(size(locs2, 1), 4);

    H2to1 = computeH_norm(locs1(rands, :), locs2(rands, :));
    inlier_flag = zeros(size(locs2, 1), 1);

    for i = 1:size(locs2, 1)
        p = [locs2(i, :)'; 1];
        p_prime = H2to1 * p;
        p_prime = p_prime([1,2]) / p_prime(3);
        err = sqrt(sum((p_prime' - locs1(i, :)) .^ 2));
        if(err < threshold)
            inlier_flag(i) = 1;
        end
    end

    num_inliers = sum(inlier_flag );
    if(num_inliers > max_inliers)
        inliers = inlier_flag;
        bestH2to1 = H2to1;
        max_inliers = num_inliers; 
        idxs = rands;
    end
end
%Q2.2.3

