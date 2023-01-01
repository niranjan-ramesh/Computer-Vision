function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
w = (windowSize - 1)/2;
[H, W] = size(im1);
dispM = zeros(H, W);
min_disp = ones(H, W) * 1e20;
mask = ones(windowSize, windowSize);
im1 = im2double(im1);
im2 = im2double(im2);


% im1 = padarray(im1, [w, w], 0, "both");
% im2 = padarray(im2, [w, w], 0, "both");

% for y = w + 1: H
%     for x = w + 1: W
%         min_distance = 1e20;
%         disp = 0;
%         for d = 0:maxDisp
%            if(x-d>w)
%                patch1 = im1(y-w:y+w, x-w:x+w); 
%                patch2 = im2(y-w:y+w, x-d-w:x-d+w); 
%                dist = sum(sum((patch1-patch2) .^ 2));
%                if(dist < min_distance)
%                    min_distance = dist;
%                    disp = d;
%                end
%            end
%         end
%         dispM(y, x) = disp;
%     end
% end

for d = 0: maxDisp
    im2_win =  imtranslate(im2, [d 0], "FillValues",255);
    disp_ = conv2((im1 - im2_win) .^ 2, mask, "same");
    dispM(disp_ < min_disp) = d;
    min_disp = min(min_disp, disp_);
end


