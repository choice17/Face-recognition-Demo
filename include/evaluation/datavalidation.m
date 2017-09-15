%% for report data analysis
% for face detector
inPath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\faces96');
savePath = ('C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\Cropface96');
[list] = getimgpath(inPath);
[facedetected,class]=loadsaveCropImg(list,savePath,'jpg');
 option = struct('format','jpg','size',[64 64]);
[z,zt] = checkposdetection(savePath,option);
%{
confusion matrix
thre4
2989           6
  11           0
6
2982           2
  22           0
8
2976           1
  29           0
%}
  %% to show the variant of training is important
  XX1=[];Xi1 =[]; K=400;G=10;
  %% [107 104 300 97 24 76]
  x = imread('face\NewFace\choi\76.jpg');
  nX = featureNormalize(double(x(:)));
  Xi1 =[Xi1;nX'];
  zz = featureExtractPCA(nX,K,G,U);
  xx = recoverData(zz,U,K);
  XX1 = [XX1;xx];
  %%
  figure;
  displayData(XX1);
  figure;
  displayData(Xi1);
  
%% Crossvalidation
  K=400; G=0;
%[Z,U] = featureExtractPCA([tx tstx],K,G);
Z = featureExtractPCA(tx,K,G,U);
Zt = featureExtractPCA(tstx,K,G,U);

% svm training
fprintf('training for the classifier...\n');
t = templateSVM('KernelFunction','gaussian','KernelScale',40,...
    'BoxConstraint',10); 
Mdl = fitcecoc(Z,ty','Learners',t,'Coding','onevsall');
cvmdl = crossval(Mdl);
cvmdlloss = kfoldLoss(cvmdl);
for i=1:10
[predclass] = predict(cvmdl.Trained{i},Zt);
accuracy(i,:) = sum(predclass==tsty')/length(tsty);
end
sumsvm=0;
gamma =[];
for i=1:28
    sumsvm = sumsvm+size(Mdl.BinaryLearners{i}.Alpha,1);
    gamma = [gamma Mdl.BinaryLearners{i}.KernelParameters.Scale];
end
mean(1-accuracy)
mean(gamma)
%[predclass,data] = predict(Mdl,Z);
%accuracyTr = sum(predclass==ty')/length(ty);
%fi = find(predclass==tsty');
%classMdl.accuracyTr = accuracyTr;
%cvmdl = crossval(mdl)
  
%% norm study
 K=256; G=6;
%[Z,U] = featureExtractPCA([tx tstx],K,G);
Z = featureExtractPCA(tx,K,G,U);
Zt = featureExtractPCA(tstx,K,G,U);
%L2 calc
[ZL2,Zm2] = Lnorm(Z,ty,2);
%L1 calc
[ZL1,Zm1] = Lnorm(Z,ty,1);
%L1 calc
[ZL0,Zm0] = Lnorm(Z,ty,0.5);

%save ('essexFace96trtst.mat','tx','ty','tstx','tsty','sy','Z', ...
%      'U','k','g','Zm0','Zm1','Zm2'); 

MaxClass = max(tsty);
%L2 predict
[ZTL2] = Lnorm(Zt,MaxClass,2,Zm2);
%L1 predict
[ZTL1] = Lnorm(Zt,MaxClass,1,Zm1);
%L0 predict
[ZTL0] = Lnorm(Zt,MaxClass,0.5,Zm0);
%%
[pred,accuracy] = normpredict(ZL0,ty);
[predt,accuracyt] = normpredict(ZTL0,tsty);
%% Neural Network
K=256; G=0;
net=0;
%[Z,U] = featureExtractPCA([tx tstx],K,G);
Z = featureExtractPCA(tx,K,G,U);
Zt = featureExtractPCA(tstx,K,G,U);

hiddenSizes=[1000 1000];
trainFcn = 'traingdx';
performFcn = 'crossentropy';
net = patternnet(hiddenSizes,trainFcn,performFcn);
net.performParam.regularization = 0.1;
net.layers{1}.transferFcn = 'purelin';
net.layers{2}.transferFcn = 'logsig';



Y = one2allLabel(ty);
net = configure(net, Z',Y);
[net, tr] = train(net, Z', Y);
%%
TY = one2allLabel(tsty);
py = net(Zt');
py=py == max(py); 
pY = ones(size(py)).*[0:size(Y,1)-1]';
pY=pY((py == max(py)))';
%CON    F =plotconfusion(py,TY);
testerr = 1- sum(pY==tsty)/length(pY)
