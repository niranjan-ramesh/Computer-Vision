function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
p1 = P1(1, :);
p2 = P1(2, :);
p3 = P1(3, :);
p1_prime = P2(1, :);
p2_prime = P2(2, :);
p3_prime = P2(3, :);

N = size(pts1, 1);
pts3d = zeros(N, 3);

for i = 1:N
    x = pts1(i, 1);
    y = pts1(i, 2);
    x_prime = pts2(i, 1);
    y_prime = pts2(i, 2);
    A = [y .* p3 - p2;
         p1 - x .* p3;
         y_prime .* p3_prime - p2_prime;
         p1_prime - x_prime .* p3_prime];
    [U, D, V] = svd(A);
    X = V(:, end)';
    X = X / X(4);
    pts3d(i, :) = X(1:3);
end


