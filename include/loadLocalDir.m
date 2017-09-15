function [list,m]=loadLocalDir(filetype,filesize)
%return all the list and total number of item list
%return dir of folder without filetype
%filetype is a string of filetype
%filesize is to filter blank file.
     a=cd;
     if nargin<1 
         s=dir;
     else
         s=dir(strcat('*.',filetype));
         if nargin<2
         filesize=3;
         end
         s = s([s.bytes]'>filesize*1000);
     end
     sn= {s.name}';
     if nargin<1
        m = [s.isdir]';
        sn = {sn{m}}';
        sn = {sn{3:end}}';
     end
     
     m=size(sn,1);
        list = strcat(a,'\',sn);
end
     