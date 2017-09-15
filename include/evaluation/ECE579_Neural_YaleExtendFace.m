%% Neural network testing
clear all;
local = 'C:\Users\takchoi\Desktop\MS\Umdearborn\LectureNote\ECE579\Project';
cd(local);
addpath('include');
addpath('neuralnetwork');

%load include\faceEssex96_6464.mat;
load include\YaleFaceCrop.mat

% normalizefeature
[nx,stdx,meanx] = featureNormalize(x);
% should be 80% of training, 20% of testing 
ratio = 0.66;
[tx,ty,tstx,tsty,sy,rn] = shuffleImg(nx,y,ratio);
cImg=classImage(x,y);



%% pca feature
% calc covariance of tx and output 
fprintf(' trainning ... \n')
[U,S ] = pca(tx');
% input K - number of dimension
% input G - reject first g basis(lumination component)by Wiki
% [Z,Ux] = projectData(X,K,g);
k=128;
g=10;
% obtain Z for training
Z = projectData(tx',U,k,g);
% obtain Zt for testing
Zt = projectData(tstx',U,k,g);
%% auto Encoder
[ay]= one2allLabel(ty);
rng('default');
hiddenSize1 = 400;
autoenc1 = trainAutoencoder(tx,hiddenSize1, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);
feat1 = encode(autoenc1,tx);

hiddenSize2 = 144;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',50, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);
feat2 = encode(autoenc2,feat1);

deepnet = stack(autoenc1,autoenc2);
feat1 = encode(autoenc1,tx);
feat2 = encode(autoenc2,feat1);
r2 = decode(autoenc2,feat2);
r1 = decode(autoenc1,r2);
featt1 = encode(autoenc1,tstx);
featt2 = encode(autoenc2,featt1);
rt2 = decode(autoenc2,featt2);
rt1 = decode(autoenc1,rt2);


    
%% simple neural network

% initialize Theta
input_layer_size = 128;
hidden_layer_size = 200;
num_labels = length(unique(y));
options = optimset('MaxIter', 200);
lambda= 10;

% neural network model classification
model = myneuralnetwork(input_layer_size,...
    hidden_layer_size,num_labels,...
    Z, ty', lambda,options);
[predclass,accuracy] = mynetworkpred(model,Zt,tsty);

%%
figure;
for i=1:2
plot3(Zv(predclass==i,1),Zv(predclass==i,2),Zv(predclass==i,3),'.');
hold on;
end
%% SVM one vs all gaussian kernel auto gamma/error selection

t = templateSVM('KernelFunction','gaussian','KernelScale','auto');
[Mdl,HyperparameterOptimizationResults] = fitcecoc(Z,ty','Learners',t,'Coding','onevsall');

%%

[predclass,data] = predict(Mdl,Zt);
accuracy = sum(predclass==tsty')/length(tsty);
fi = find(predclass==tsty');
Mdl.BinaryLearners{1}.Alpha;


%%
figure;
for i=1:10
subplot 121;displayData(tstx(:,fi(1+(i-1)*(100):i*100))');subplot 122;displayData(cImg(:,tsty(fi(1+(i-1)*(100):i*100))+1)');
pause;
end
