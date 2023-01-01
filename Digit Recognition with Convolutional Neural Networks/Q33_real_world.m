h = 28;
w = 28;

input = zeros(h*w, 10);

for i = 0:9
    image = imread(append("../data/", num2str(i), ".png"));
    
%     Throws error if image is already grayscale
    if ndims(image) == 3
        image = rgb2gray(image);
    end
%     Trained for 28 x 28
    image = imresize(image, [h, w]);
    image = imcomplement(image)';
    input(:, i+1) = image(:);
end

layers = get_lenet();
layers{1}.batch_size = 10;
load lenet.mat
[output, P] = convnet_forward(params, layers, input);
[M, I] = max(P);

figure;
for i = 1: 10
    subplot(4, 3, i);
    imshow(reshape(input(:, i), [h w])');
    title(sprintf("Prediction: %d", I(i)-1));
end
