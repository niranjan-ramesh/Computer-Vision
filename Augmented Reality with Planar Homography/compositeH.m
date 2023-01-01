function [ composite_img ] = compositeH( H_template_to_img, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.

%% Create mask of same size as template
% mask = zeros(size(template))
mask = ones(size(template));
% figure;
% imshow(mask);

%% Warp mask by appropriate homography
mask = warpH(mask, H_template_to_img, size(img));
% figure;
% imshow(mask);

%% Warp template by appropriate homography
template = warpH(template, H_template_to_img, size(img));
% figure;
% imshow(template);

%% Use mask to combine the warped template and the image
composite_img = img;
% composite_img(mask > 1) = template(mask > 1);
composite_img(mask ~= 0) = template(mask ~= 0);
end