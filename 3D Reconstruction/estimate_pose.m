% 3.3.1 Estimate camera matrix P
% This script was originally in the `ec` dir.

function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

N = size(x, 2);
A = zeros(2 * N, 12);

for i = 1:N
    X_i = [X(:, i); 1];
    x_prime = x(1, i);
    y_prime = x(2, i);
    
    A(2*i-1, :) = [X_i', 0, 0, 0,   0,  -x_prime * X_i'];
    A(2*i, :)   = [  0,  0, 0, 0, X_i', -y_prime * X_i'];
end

[~, ~, V] = svd(A);
P = V(:, end);
P = reshape(P, [4 3])';

