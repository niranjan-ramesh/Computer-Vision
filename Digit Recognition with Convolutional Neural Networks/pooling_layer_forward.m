function [output] = pooling_layer_forward(input, layer)

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    
    
    output.height = h_out;
    output.width = w_out;
    output.channel = c;
    output.batch_size = batch_size;

    % Replace the following line with your implementation.
%     output.data = zeros([h_out, w_out, c, batch_size]);
    for i = 1:batch_size
        image = input.data(:, i);
        image = reshape(image, [h_in, w_in, c]);
        image = padarray(image, [pad, pad], 0);

        % Reused same method as in im2col_conv method.
        
        for h = 1:h_out
            for w = 1:w_out
                for channel_num = 1:c
                    pool_region = image((h-1)*stride + 1 : (h-1)*stride + k, (w-1)*stride + 1 : (w-1)*stride + k, channel_num);
                    output.data(h, w, channel_num, i) = max(pool_region, [], "all");
                end
            end
        end
    end
    output.data = reshape(output.data, [h_out*w_out*c, batch_size]);
end

