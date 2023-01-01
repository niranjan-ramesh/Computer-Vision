function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
n = length(x1);
A = zeros(2 * n, 9);

for i = 1:n
    x = x2(i, 1); 
    y = x2(i, 2);
    x_prime = x1(i, 1); 
    y_prime = x1(i, 2);

    A(2*i - 1, :) = [-x, -y, -1,  0,  0,  0, x * x_prime, y * x_prime, x_prime];
    A(2*i, :)   =   [ 0,  0,  0, -x, -y, -1, x * y_prime, y * y_prime, y_prime];

end

[~, ~, V] = svd(A);
H2to1 = V(:, end);
H2to1 = reshape(H2to1, [3, 3])';

end
