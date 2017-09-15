function [x,y] = loadTrImg(p,option)
%option.depth .format(char) .imgresize
fm = option.format;
size = option.size;
class=0;
local = cd;
while iscell(p)
p = p{1};
end
cd(p);
x=[];
y=[];
list = p;    
    
    %%%%load all the path in p
    [list0,lm] = loadLocalDir();
    list = [list; list0];
    %%%move to next depth%%%  
    if ~isempty(list0)
        for i=1:lm
            pa = char(list0{i});
            cd(pa);
            [list1,Lm] = loadLocalDir();
            list = [list; list1];
        end
    end
fprintf('\n Loading image 10 percent for ...\n');
for i=1:length(list)
[x,y,class]=loadImgFromPath(x,y,char(list{i}),class,fm,size);
if mod(i,ceil(length(list)/10))==0
    fprintf('...');
end
cd(local);
end
fprintf('finished loading!!\n');
end