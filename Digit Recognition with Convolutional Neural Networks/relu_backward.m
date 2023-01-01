function [input_od] = relu_backward(output, input, layer)

% Replace the following line with your implementation.
% (dL/df) * (df/dinput)

% dL/df is derivative w.r.t to output of activation.

% derivative of activation function w.r.t input
% (df/dinput) = 1 when f > 0 else 0
grad_input = zeros(size(input.data));
grad_input(input.data > 0) = 1;

input_od = output.diff .* grad_input;
end
