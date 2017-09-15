function simpleNeuralNetworkModel = myneuralnetwork(input_layer_size,...
    hidden_layer_size,num_labels,...
    Z, ty, lambda,options)
% neural network model input -
% input_layer_size: feature size
% hidden_layer_size: 
% num_labels: output size
% Z: input data [m n] m: number of data, n: size of each data(features)
% ty: input data label [m 1] 
% lambda: regularization parameter 

if size(ty,2) == size(Z,1)
    ty = ty';
end

%randomize weights 
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);
% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

% Create "short hand" for the cost function to be minimized                                                                                            
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, Z, ty, lambda);
                               
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

pred = predict(Theta1, Theta2, Z);
%predt = predict(Theta1, Theta2, Zt);
%fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == ty')) * 100);
%fprintf('\nTesting Set Accuracy: %f\n', mean(double(predt == tsty')) * 100);
simpleNeuralNetworkModel.Theta1 = Theta1;                                
simpleNeuralNetworkModel.Theta2 = Theta2;                                        
simpleNeuralNetworkModel.pred = mean(double(pred == ty)) * 100; 

end
                               
                               

