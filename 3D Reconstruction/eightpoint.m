function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
disp("Eight Point algorithm");
N = size(pts1, 1);

pts1 = pts1/M;
pts2 = pts2/M;

A = zeros(N, 9);
for i = 1:N
    x = pts1(i, 1);
    y = pts1(i, 2);

    x_prime = pts2(i, 1);
    y_prime = pts2(i, 2);

    A(i, :) = [x_prime*x, x_prime*y, x_prime, y_prime*x, y_prime*y, y_prime, x, y, 1];

end


[~, ~, V] = svd(A);
F = V(:, end);
F = reshape(F, [3,3])';

[U, D, V] = svd(F);
D(end) = 0;
F = U * D * V';
F = refineF(F, pts1, pts2);

scale = [ 1/M,   0, 0;
            0, 1/M, 0
            0,   0, 1;
        ];

F = scale' * F * scale;

end

