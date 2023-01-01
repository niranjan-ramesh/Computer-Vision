function [output] = inner_product_forward(input, layer, param)

d = size(input.data, 1);
k = size(input.data, 2); % batch size
n = size(param.w, 2);

output.batch_size = k;
output.height = n;
output.width = 1;
output.channel = 1;
% Shape of multiplication: (n x prev_neurons) * (prev_neurons x batch_size) + bias
output.data = transpose(param.w)*input.data + transpose(param.b);
end
