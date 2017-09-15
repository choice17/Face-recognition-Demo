%% for face extract on the data base
clearvars;
close all;
% add library
addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project');
addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\Machine Learning\Exercise\machine-learning-ex7\ex7');
% make choice to run this programm
prompt = 'load data from :[1]path/[2].mat ? Enter. ';
gopath = input(prompt);
if gopath==1
% load training image path
pcd= cd;
p= 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faces94';
%input option.depth .format(char) .imgresize
imgsize=[64 64];
option = struct('format','jpg','size',imgsize);
[x,y] = loadTrImg(p,option);
% to be complete
cd(pcd);
end
%%
%option = struct('format','jpg','size',[64 64]);
% load and save the crop image in folder();
% load path list of image
local = 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project';
cd(local);
addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project');
addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\Machine Learning\Exercise\machine-learning-ex7\ex7');
%inPath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faces96');
inPath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\Cropface96');
savePath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\Cropface96');

%load and crop img and put it in savePath
  [list] = getimgpath(inPath);
  [facedetected,class]=loadsaveCropImg(list,savePath,'jpg');
%load the image into workspace
  option = struct('format','jpg','size',[64 64]);
  [x,y] = loadTrImg(savePath,option);

save ('faceCropYaleB_6464.mat','x','y');
%%  load precaptured image directly
fprintf('\n loading data ... \n')
%load faceCropYaleB_6464.mat;
load faceEssex96_6464.mat;

fprintf(' preprocessing data: normalize/shuffle/create train/test data.\n')
% normalizefeature
[nx,stdx,meanx] = featureNormalize(x);
% should be 80% of training, 20% of testing 
ratio = 0.8;
[tx,ty,tstx,tsty,sy,rn] = shuffleImg(nx,y,ratio);
cImg=classImage(nx,y);


fprintf(' It takes %f percent of dataset as training data for face \n',ratio*100)
fprintf(' press to continue...\n')
pause;

%% pca 
fprintf('\n processing pca(), it takes around a mintue... \n')
% calc covariance of tx and output 
[U,S ] = pca(tx');
% input K - number of dimension
% input G - reject first g basis(lumination component)by Wiki
% [Z,Ux] = projectData(X,K,g);
k=800;
g=10;
% obtain Z for training
fprintf(' trainning ... \n')
Z = projectData(tx',U,k,g);
% obtain Zt for testing
Zt = projectData(tstx',U,k,g);
%recover Data
%[Zx] = recoverData(Z,U,k,g);
%[Zx] = recoverData(Zt,U,k,g);

%learning processing
%SVM or neural classification logistic function on Ux with class y
fprintf(' press to continue...\n')
pause;

%%
fprintf(' training in different length distance method .\n')
%calc Lnorm of the pca reduced sample w.r.t. Y class 
%L2 calc
[ZL2,Zm2] = Lnorm(Z,ty,2);
%L1 calc
[ZL1,Zm1] = Lnorm(Z,ty,1);
%L1 calc
[ZL0,Zm0] = Lnorm(Z,ty,0.5);

%save ('essexFace96trtst.mat','tx','ty','tstx','tsty','sy','Z', ...
%      'U','k','g','Zm0','Zm1','Zm2'); 


%using norm to predict;

MaxClass = max(tsty);
%L2 predict
[ZTL2] = Lnorm(Zt,MaxClass,2,Zm2);
%L1 predict
[ZTL1] = Lnorm(Zt,MaxClass,1,Zm1);
%L0 predict
[ZTL0] = Lnorm(Zt,MaxClass,0.5,Zm0);
fprintf(' press to continue...\n')
pause;

%% prediction, performance test
fprintf(' making prediction on each Lnorm on test data .\n')
[pred1,accuracy1] = normpredict(ZL1,ty);
[predt1,accuracyt1] = normpredict(ZTL1,tsty);
fprintf('\n accuracy of training data: %f \n',accuracy1);
fprintf(' accuracy of test data: %f \n',accuracyt1);
%% studying the confident value
% to compare the probability value of the minimum value of the class
% in the training data
minZL = min(ZL1,[],2);
H=histogram(minZL,100);
Hy = [H.Values 0];
Hx = H.BinEdges;
Hyfc = flip(cumsum(flip(Hy)))./sum(Hy);
plot(Hx,Hyfc);

%%
pw=predt1(predt1~=tsty');
figure('Name','query vs actual');
for i=randperm(size(tstx,2))
%for i=1:10
    %ii=(i+10*(i-1)):i*10;
    titlePred = strcat('PredictClass :',string(predt1(i)+1));
    titleAct = strcat('Actual Class :',string(tsty(i)+1));
    subplot 131;   
    displayData(tstx(:,i)');
    title('Query Image');
    subplot 132;
    displayData(cImg(:,predt1(i)+1)');
    title(titlePred);
    subplot 133;
    displayData(cImg(:,tsty(i)+1)');
    title(titleAct);
    pause;
end
%%
%prompt = 'clear vars?[Y]/[N]:';
%%if input(prompt,'s')=='Y'
%    clearvars;
%end

%% raw query image 
r = randperm(size(list,1)-1)+1;
figure;
for i=r(1:end)
queryPath=list(i);
cd(char(queryPath));
s=dir('*.pgm');
s=s([s.bytes]>3000);
m = size(s,1);
ran = randi([1 m],1);
inImg = imread(char(strcat(queryPath, ...
    '\',s(ran).name)));

tic;
[pred,confident] = predQueryImage(inImg,Zm1,U,k,g,1,imgsize,Hx,Hyfc);
t=toc;
titleQuery = strcat('QueryImage');
titlePred = strcat('PredictClass :',string(pred+1));
subplot 121; imshow(inImg); title(char(titleQuery));
subplot 122; displayData([cImg(:,pred+1)']); title(titlePred);
fprintf('==predict Class = %f, confident = %f, prediction time : %d\n',...
         pred+1,confident*accuracy1,t);
pause;
end
cd(local);
%%
clear cam;
cam = webcam;
preview(cam);
P=true;
figure(3);
while P==true
fprintf('press button to test\n');
pause;
inImg=snapshot(cam);

tic;
[pred,confident] = predQueryImage(inImg,Zm1,U,k,g,1,imgsize,Hx,Hyfc);
t=toc;
subplot 121; imshow(inImg); title('QueryImage');
subplot 122; displayData([cImg(:,pred+1)']); title('ClassImage');

fprintf('==predict Class = %f, confident = %f, prediction time : %d\n',...
         pred+1,confident*accuracy1,t);

end
