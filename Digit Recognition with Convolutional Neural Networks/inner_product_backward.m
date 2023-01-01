function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
param_grad.b = zeros(size(param.b));
param_grad.w = zeros(size(param.w));

for i = 1:input.batch_size
%     Gradient calculated wrt output of this layer
    grad_output = transpose(output.diff(:, i));
%     dh/db = 1
    param_grad.b = param_grad.b + grad_output;

    image = input.data(:, i);
%     Each neuron of input image contributes to each output neuron
    param_grad.w = param_grad.w + (image * grad_output);

% dh/dh-1 is the weights of the layer
input_od = param.w * output.diff; 


end



end
