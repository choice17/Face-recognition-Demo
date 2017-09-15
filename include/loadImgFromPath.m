function [x,y,c,z,zt] = loadImgFromPath(X,Y,p,iy,fm,imsize,fimbytes,z,zt)
%input string P: path | iy: class | fm: format | size: resize[y x]
%to output a set of image in x and store in gray value
%where x has dimension [n,m] n:# of pixels,m:# of images
%where y has dimension [m 1] with class iy
%images should have the same size in the path
%will check if the file is broken or empty by checking bytes>3
if nargin<7
    fimbytes = 3;
    z=[];
    zt=[];
end
x=X;
y=Y;
c=iy;
fo = strcat({'*.'},{fm});
local = cd;
while iscell(p)
    p = p{1};
end
cd(p);
s = dir(char(fo));
if ~isempty(s)
m = [s.bytes]';
z=[z;m];
zt=[zt;strcat(cd,'\',{s.name}')];
n = sum(m>fimbytes);
list = {s.name}';
list = {list{m>fimbytes}}';

y = [y iy.*ones(1,n)];
for i=1:n
rawimage = imread(char(list{i}));
    if size(rawimage,3)==3
        ir = rgb2gray(rawimage);
    else
        ir=rawimage;
    end
img = double(ir);
img = imresize(img,imsize);
x = [x,img(:)];
end
c=iy+1;
end
cd(local);
end


