function [y,cy]=loadsaveCropImg(list,savePath,filetype)
%load the image in list and crop the face detected
%with the detected filetype
%return [facedetected of image, class of the image]
fprintf('this crop faces... take about mintues\n');

Class = size(list,1);
Local = cd;
y=[];
class = 0;
cy=[];
for i=1:Class
% go to list and load dir
    cd(char(list(i,1)));
    [imglist] = loadLocalDir(filetype);
    if ~isempty(imglist)
        fprintf('create class: %f on the list item: %f \n',class,i);
        mkdir (char(strcat(savePath,'\',num2str(class))));
        imgM = size(imglist);
        for j=1:imgM
            %load image
            [img] = imread(char(imglist(j,1)));
            %crop image
            [cImg,bbox] = cropfaceImg(img);
            %save class
            cy=[cy class];
            %record the succeed in face detection
            if isempty(bbox)
                y=[y 0];
            else 
                y=[y 1];
            saveFilePath = strcat(savePath,'\',num2str(class), ...
                '\',num2str(j),'.',filetype);
            imwrite(cImg,char(saveFilePath));
            end
   %         saveFilePath = strcat(savePath,'\',string(class), ...
   %             '\',string(j),'.',filetype);
   %         imwrite(cImg,char(saveFilePath));
            
        end
        class=class+1;    
    end
end
    cd(Local);
end
