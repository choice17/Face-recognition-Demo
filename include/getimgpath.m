function [list] = getimgpath(inPath)
%option.depth .format(char) .imgresize
p=inPath;
local = cd;
if iscell(p)
    p = p{1};
end
cd(p);  
list = p;    
    
    %%%%load all the path in p
    [list0,lm] = loadLocalDir();
    list = [list; list0];
    %%%move to next depth%%%  
    if ~isempty(list0)
        for i=1:lm
            pa = char(list0{i});
            cd(pa);
            [list1] = loadLocalDir();
            list = [list; list1];
        end
    end
    cd(local);
end