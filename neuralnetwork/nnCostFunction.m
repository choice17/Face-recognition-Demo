function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

             
% Setup some useful variables
m = size(X, 1);


% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
%%%%%%%%%%%%%%%%%%%pre-calculas%%%%%%%%%%%%%%%%%%%
% adding bias to input 
%out1_2 = [ones(m,1), X];

% to relabel output to oneVsAll
tempy = zeros(size(y));
for c =1:num_labels
tempy(:,c) = (y==c); 
end
%%%%%%%%%%%%%%%%%%%for input to hidden layer%%%%%%%%%%%%%%%%%%%
a1 = [ones(m,1) , X];
%for hidden layer
z2 = a1*Theta1';
o2 = sigmoid(z2);
a2 = [ones(m,1), o2];
%for output layer
z3 = a2*Theta2';
a3 = sigmoid(z3);
pred = a3;
%%%%%%%%%%%%%%%%%%%%Compute CostFunction%%%%%%%%%%%%%%%%%%%%%%%%%%
tempTheta1 = Theta1;
tempTheta1(:,1)=0; %neglect bias theta
tempTheta2 = Theta2;
tempTheta2(:,1)=0; %neglect bias theta
delta = -(tempy).*log(pred) - (1-tempy).*log(1-pred);
regularTerm = sum((tempTheta1(:)).^2) +sum((tempTheta2(:)).^2);
J = 1/m .* sum(delta(:)) + lambda/(2*m) .* regularTerm;


% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% backpropagation Vectorized term ====================================
delta_3 = a3 - tempy;
delta_2 = delta_3*Theta2;
delta_2 = delta_2(:,2:end).*sigmoidGradient(z2);
tri2 = (1/m) .* (delta_3'*a2);
tri1 = (1/m) .* (delta_2'*a1);
tempTheta2 = Theta2;
tempTheta2(:,1) =0;
tempTheta1 = Theta1;
tempTheta1(:,1) =0;
regTri2 = tri2 + lambda/m .* tempTheta2;
regTri1 = tri1 + lambda/m .* tempTheta1;
Theta2_grad = regTri2;
Theta1_grad = regTri1;

%%================================================================
%a1 = [ones(m,1) , X];
%tri2 = zeros(num_labels,hidden_layer_size+1);
%tri1 = zeros(hidden_layer_size,input_layer_size+1);

%for i = 1:m
%    z2 = Theta1*a1(i,:)'; 
%    a2 = [1; sigmoid(z2)];
%    z3 = Theta2*a2;
%    a3 = sigmoid(z3);
%    delta_3 = a3 - tempy(i,:)';
%    delta_2 = Theta2'*delta_3;                     %2 steps to neglect delta2(1) bias term
%    delta_2 = delta_2(2:end).*sigmoidGradient(z2);
 %   tri2 = tri2 + delta_3*a2';                     %partial derivative of Theta2
 %   tri1 = tri1 + delta_2*a1(i,:);                     %partial derivative of Theta1
%end

%regularTheta2 = lambda/m .* tempTheta2;
%regularTheta1 = lambda/m .* tempTheta1;
%Theta2_grad = 1/m.*tri2 + regularTheta2;                                    %update the Theta2 value after summation
%Theta1_grad = 1/m.*tri1 + regularTheta1 ;                                    %update the Theta1 value after summation


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
