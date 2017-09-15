function [ZL,Zmc] = Lnorm(X,y,typeL,Zm)
%input X have size [m K] m-no. of sample | K-dimension of 1 sample
%with provided respect class y =[1 m]; y:[0 classSize-1]
%typeL is the type of length 1: L1 norm, length 2: L2 norm, ;length 0.5:
%L.5 norm
%w/o Zm, this functino is gonna to train a mean feature for classes
%w/ Zm, input y as a max class value for class: [0:maxClassvalue]

Z=X;
classSize=max(y)+1;
Zmc = zeros(classSize,size(Z,2));
ZL = zeros(size(Z,1),classSize);

if nargin<4
    for i=0:classSize-1
       Zmc(i+1,:) = mean(Z(y==i,:));  
    end
    
    if nargin<3    
    typeL=2;
    end
else
    Zmc=Zm;
end


if typeL==1
    for i=0:classSize-1
        ZL(:,i+1) = sum(abs(Z-Zmc(i+1,:)),2);
    end
elseif typeL==2
    for i=0:classSize-1
        ZL(:,i+1) = sum((Z-Zmc(i+1,:)).^2,2);
    end
elseif typeL==0.5
    for i=0:classSize-1
        ZL(:,i+1) = sum(sqrt(abs(Z-Zmc(i+1,:))),2);
    end
end
end