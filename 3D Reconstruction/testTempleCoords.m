% A test script using templeCoords.mat
%
% Write your code here
%

% Q 3.1.5
% 1
image1 = imread("../data/im1.png");
image2 = imread("../data/im2.png");

corres = load("../data/someCorresp.mat");

% 2
F = eightpoint(corres.pts1, corres.pts2, corres.M);

% 3
temple_coord = load("../data/templeCoords.mat");
pts1 = temple_coord.pts1;
pts2 = epipolarCorrespondence(image1, image2, F, pts1);

% 4
intrinsics = load("../data/intrinsics.mat");
K1 = intrinsics.K1;
K2 = intrinsics.K2;
E = essentialMatrix(F, K1, K2);

% 5
ext_1 = [1, 0, 0, 0;
         0, 1, 0, 0; 
         0, 0, 1, 0];

P1 = K1 * ext_1;
candidates = camera2(E);

% 6 and 7

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
    disp(n);
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

error_1 = sum(sqrt(sum((projection_1 - pts1) .^ 2, 2))) / num_points;
error_2 = sum(sqrt(sum((projection_2 - pts2) .^ 2, 2))) / num_points;

fprintf("Mean Reprojection error for pts1: %f\n", error_1);

fprintf("Mean Reprojection error for pts2: %f\n", error_2);


% 8
X = pts3d(:, 1);
Y = pts3d(:, 2);
Z = pts3d(:, 3);
plot3(X, Y, Z, '.', 'MarkerSize', 15);
axis equal;

R1 = eye(3);
t1 = zeros(3, 1);
R2 = K2 \ P2(1:3, 1:3);
t2 = K2 \ P2(:, 4);

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');

