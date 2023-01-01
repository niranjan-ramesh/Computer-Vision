%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

% load the trained weights
load lenet.mat

y_actuals = zeros(size(xtest, 2), 1);
y_preds = y_actuals;
%% Testing the network
% Modify the code to get the confusion matrix
confusion_matrix = zeros(10, 10);
for i=1:100:size(xtest, 2)
    [output, P] = convnet_forward(params, layers, xtest(:, i:i+99));
    [M, I] = max(P);
    for j = 1:size(I, 2)
        y = ytest(i+j-1);
        y_hat = I(j);
        confusion_matrix(y, y_hat) = confusion_matrix(y, y_hat) + 1;
        y_actuals(i+j-1) = y;
        y_preds(i+j-1) = y_hat;
    end
end
disp(confusion_matrix);
figure;
confusionchart(y_actuals, y_preds);
