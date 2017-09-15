function [pred,accuracy] = mynetworkpred(in_model,in_X,in_y)

if nargin==3
if size(in_y,1)==1
    in_y=in_y';
end
end

Theta1 = in_model.Theta1;
Theta2 = in_model.Theta2;

pred = neuralpredict(Theta1, Theta2, in_X);

if nargin==3
accuracy = mean(double(pred == in_y)) * 100; 
end
end