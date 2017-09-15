function [relabely] = one2allLabel(y)
y=y';
num_labels = max(y);
tempy = zeros(size(y));
for c =0:num_labels
tempy(:,c+1) = (y==c); 
end
relabely = tempy';

end
