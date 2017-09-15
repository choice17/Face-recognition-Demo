function [pred,confident] = predQueryImage(inImg,Zm,U,k,g,normChoice,imgsize,Hx,Hyfc)
%to pred the query image, return class num and the confident
%INPUT: inImg: input raw image| Zm: trained classes mean Norm for features
%       U: eigenvector basis  | k : selected K-dimension of U
%       g: rejected of first dimension in U
%       Lnorm: chosen length of Lnorm

if size(inImg,3)==3
inX = rgb2gray(inImg);
else 
    inX = inImg;
end
classize = size(Zm,1);
%face detect
inX = cropfaceImg(inX);
%normalize data
inX = imresize(inX,imgsize);
inX = double(inX(:));
[nx] = featureNormalize(inX);
%projectData
Z = projectData(nx',U,k,g);
%calc Lnorm w.r.t. classes
ZTL = Lnorm(Z,classize-1,normChoice,Zm);
%pred class
pred = find((ZTL==min(ZTL,[],2)))-1; 
minZTL = min(ZTL,[],2);
tempfind = abs(Hx-minZTL);
tempfind = tempfind==min(tempfind);
confident = Hyfc(tempfind);
end

