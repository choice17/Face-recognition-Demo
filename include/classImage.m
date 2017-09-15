function cImg = classImage(tx,ty)
%to select the first image of each class as class reference image
%INPUT: size(tx) = [n,m] , n: total pixel of image/m: number of sample img
%       ty is the reference class value w.r.t. each sample

class = max(ty);
n = size(tx,1);
cImg = zeros(n,class+1);
for i=1:class+1
    tmp = tx(:,ty==(i-1));
    cImg(:,i)=tmp(:,1);
end
end
    
    