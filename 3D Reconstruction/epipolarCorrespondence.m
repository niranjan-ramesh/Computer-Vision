function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
[~, W, ~] = size(im2);
N = size(pts1, 1);
window = 10;


pts2 = zeros(N, 2);
for i = 1:N
    p1 = [pts1(i, :), 1];
    l_prime = F * p1';
    x1 = round(pts1(i, 1));
    y1 = round(pts1(i, 2));
    target_window = im1(y1-window:y1+window, x1 - window:x1+window, :);
    min_distance = 1e20;
    search_start = max(0, x1 - 20);
    for j = search_start:W - window
        
%         l = [a b c]'
%         ax + by + c = 0
%         y = (-c -a*x)/b
        x_prime = j;
        y_prime = (-l_prime(3) - l_prime(1)*x_prime)/l_prime(2);
%         p_prime = [x_prime y_prime 1];
        
        x2 = round(x_prime);
        y2 = round(y_prime);
        candidate_window = im2(y2-window:y2+window, x2-window:x2+window, :);
        distance = sqrt(sum((target_window(:) - candidate_window(:)) .^ 2));
        if(distance < min_distance)
            pts2(i, :) = [x_prime y_prime];
            min_distance = distance;
        end
    end
end

