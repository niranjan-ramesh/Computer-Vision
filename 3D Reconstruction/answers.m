% Q 3.1.1

image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");
corres = load("../data/someCorresp.mat");

pts1 = corres.pts1;
pts2 = corres.pts2;
F = eightpoint(pts1, pts2, corres.M);
format long;
disp('F: ');
disp(F);

displayEpipolarF(image1, image2, F);

% Q 3.1.2
epipolarMatchGUI(image1, image2, F);

% Q 3.1.3
load("../data/intrinsics.mat");
E = essentialMatrix(F, K1, K2);
disp("Essential matrix :");
disp(E);

% Q 3.1.4
ext_1 = [1, 0, 0, 0;
         0, 1, 0, 0; 
         0, 0, 1, 0];
P1 = K1 * ext_1;
candidates = camera2(E);

max_num = 0;
for i = 1:4
    candidate_ext = candidates(:, :, i);
    candidate_P2 = K2 * candidate_ext;
    pts3d_candidate = triangulate(P1, pts1, candidate_P2, pts2);
    n = 0;
    for j = 1:size(pts3d_candidate, 1)
        if(pts3d_candidate(j, 3) > 0)
            n = n + 1;
        end
    end
%     disp(n);
    if(n > max_num)
        P2 = candidate_P2;
        pts3d = pts3d_candidate;
    end
end

num_points = size(pts3d, 1);
projection_1 = [pts3d ones(num_points, 1)] * P1';
projection_1 = projection_1(:, 1:2) ./ projection_1(:, 3);
projection_2 = [pts3d ones(num_points, 1)] * P2';
projection_2 = projection_2(:, 1:2) ./ projection_2(:, 3);

error_1 = sum(sqrt(sum((projection_1 - corres.pts1) .^ 2, 2))) / num_points;
error_2 = sum(sqrt(sum((projection_2 - corres.pts2) .^ 2, 2))) / num_points;

fprintf("Mean Reprojection error for pts1: %f\n", error_1);

fprintf("Mean Reprojection error for pts2: %f\n", error_2);



