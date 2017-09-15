function [tx,ty,tstx,tsty,sy,rn] = shuffleImg(nx,y,ratio)

n = length(y);
sy = randperm(n);
shuffleY=y(sy);
rn = ceil(ratio*n);
tx= nx(:,sy(1:rn));
tstx = nx(:,sy(rn+1:end));
ty = shuffleY(1:rn);
tsty = shuffleY(rn+1:end);
end    