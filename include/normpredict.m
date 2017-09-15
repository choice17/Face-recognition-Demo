function [pred,accuracy] = normpredict(ZL,ty)
% INPUT: ZL the norm calculation w.r.t. to diff Class
%        size(ZL) = [m classize]
%        where rm is the number of sample
%        ty is the class value refer to each sample
[n,classize] = size(ZL);
pred=zeros(n,1);
for i = 1:n
    pred(i,1) = find((ZL(i,:)==min(ZL(i,:),[],2)))-1; 
end
% accuracy
accuracy = sum(pred==ty')/n;
end