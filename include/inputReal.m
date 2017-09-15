%% video input for trainning
%registration
cam = webcam;
preview(cam);
pause;
vidRes = cam.Resolution;

imG = zeros(480,640,3,40);
for i=1:40
    img=snapshot(cam);
    imG(:,:,:,i)=img;
    pause(0.2);
end
clear cam;

figure;
for i =1:40
    imshow(uint8(imG(:,:,:,i)));
    pause(0.2);
end
mkdir choi
path = 'choi';
cd(path);
for i=1:40
    imwrite(uint8(imG(:,:,:,i)),char(strcat(string(i),'.jpg')),'JPEG');
end
fprintf('tryme \n');
%%
cd('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\')
path = 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\choi';
mkdir cropfolder
savePath = 'cropfolder';
%load and crop img and put it in savePath
  [list] = getimgpath(path);
  
  [facedetected,class]=loadsaveCropImg(list,savePath,'jpg');

  
  %%
  %load the image into workspace
  option = struct('format','jpg','size',[64 64]);
  [x,y] = loadTrImg(savePath,option);

save ('faceEssex96_6464.mat','x','y','facedetected','class');
