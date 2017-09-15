%% for face extract on the data base
clearvars;
close all;
% add library
%addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project');
%addpath('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\Machine Learning\Exercise\machine-learning-ex7\ex7');
% make choice to run this programm
%prompt = 'load data from :[1]path/[2].mat ? Enter. ';
%gopath = input(prompt);
%if gopath==1
% load training image path
%pcd= cd;
%p= 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faces94';
%input option.depth .format(char) .imgresize
%option = struct('format','jpg','size',[64 64]);
%[x,y] = loadTrImg(p,option);
% to be complete
%cd(pcd);
%end
%%
%option = struct('format','jpg','size',[64 64]);
% load and save the crop image in folder();
% load path list of image
%inPath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faces96');
%savePath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faceCrop');
%  [list] = loadimgpath(inPath);
%  loadsaveCropImg(list,savePath);
% load the path to 
% 




%% load precaptured image directly
fprintf('\n loading data ... \n')
load faceYale94_6464.mat;

fprintf(' preprocessing data: normalize/shuffle/create train/test data.\n')
% normalizefeature
[nx,stdx,meanx] = featureNormalize(x);
% should be 80% of training, 20% of testing 
ratio = 0.7;
[tx,ty,tstx,tsty,sy,rn] = shuffleImg(nx,y,ratio);
cImg=classImage(nx,y);

fprintf(' press to continue...\n')
pause;

%% pca 
fprintf('\n processing pca(), it takes around a mintue... \n')
% calc covariance of tx and output 
[U,S ] = pca(tx');
% input K - number of dimension
% input G - reject first g basis(lumination component)by Wiki
% [Z,Ux] = projectData(X,K,g);
k=400;
g=10;
% obtain Z for training
fprintf(' trainning ... \n')
Z = projectData(tx',U,k,g);
% obtain Zt for testing
Zt = projectData(tstx',U,k,g);
%recover Data
[Zx] = recoverData(Z,U,k,g);
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
%using norm to predict;
%L2 predict
[ZTL2] = Lnorm(Zt,tsty,2,Zm2);
%L1 predict
[ZTL1] = Lnorm(Zt,tsty,1,Zm1);
%L0 predict
[ZTL0] = Lnorm(Zt,tsty,0.5,Zm0);
fprintf(' press to continue...\n')
pause;

%% prediction, performance test
fprintf(' making prediction on each Lnorm on test data .\n')
[pred2,accuracy2] = normpredict(ZL2,ty);
[predt2,accuracyt2] = normpredict(ZTL2,tsty);
fprintf('\n accuracy of training data: %f \n',accuracy2);
fprintf(' accuracy of test data: %f \n',accuracyt2);
%%
pw=predt2(predt2~=tsty');
figure('Name','query vs actual');
for i=randperm(size(tstx,2))
%for i=1:10
    %ii=(i+10*(i-1)):i*10;
    displayData([tstx(:,i)';cImg(:,tsty(i)+1)']);
    pause;
end
%%
prompt = 'clear vars?[Y]/[N]:';
if input(prompt,'s')=='Y'
    clearvars;
end
