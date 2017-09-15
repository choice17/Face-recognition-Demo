function [Mdl,classMdl] = trainNewFace(operation)
%operation:1 - trainexistingfaceset
%tunable parameter
%K - number of pca feature points extraction
%ratio - ratio of whole dataset for training/cv 
%KernelScale - gamma value for SVM
%Boxconstraint - error penalty parameter
%HyperParameter initialization

K=400;
ratio=0.63;
KernelScale = 40;
BoxConstraint = 10;

if nargin==0 
    operation=0;
end
if operation ==0
    training = inputdlg('input num of new face','training',1);
    training = str2double(training{1});
    for i=1:training
        [list] = saveNewface();
    end
elseif operation ==1
    %only for evaluation
    list = 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project\face\NewFace\';
end
    
Path = getimgpath(list);
savePath = Path;
%load the image into works`pace
fprintf('loading data set...\n');
load data\YaleFaceCrop.mat
option = struct('format','jpg','size',[64 64]);

fprintf('combining new set...\n');
[Nx,Ny] = loadTrImg(savePath,option);
x = [x Nx];
y = [y Ny+max(y)];

% normalizefeature
[nx,stdx,meanx] = featureNormalize(x);
% should be 63.8% of training, 36.2% of testing 
[tx,ty,tstx,tsty,sy,rn] = shuffleImg(nx,y,ratio);
cImg=classImage(tx,ty);

% pca feature extraction 
G=0;
[Z,U] = featureExtractPCA([tx tstx],K,G);
Z = featureExtractPCA(tx,K,G,U);
Zt = featureExtractPCA(tstx,K,G,U);

% svm training
fprintf('training for the classifier...\n');
t = templateSVM('KernelFunction','gaussian','KernelScale',KernelScale,...
    'BoxConstraint',BoxConstraint);
Mdl = fitcecoc(Z,ty','Learners',t,'Coding','onevsall');
[predclass] = predict(Mdl,Zt);
accuracy = sum(predclass==tsty')/length(tsty);
%fi = find(predclass==tsty');
%classMdl.accuracyTr = accuracyTr;
classMdl.accuracy = accuracy;
classMdl.cImg = cImg;
classMdl.U = U;
classMdl.K = K;
classMdl.G = G;

save data/predictMdl.mat Mdl classMdl ;
end