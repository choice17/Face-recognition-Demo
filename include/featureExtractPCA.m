function [Z,U] = featureExtractPCA(X,K,G,in_U)
fprintf('\n processing feature extraction, it takes around a mintue... \n')
k=K;g=G;
if nargin<4 %training Mode
% calc covariance of tx and output 
% input K - number of dimension
% input G - reject first g basis(lumination component)by Wiki
% [Z,Ux] = projectData(X,K,g);
    [U,S ] = pca(X');
    if nargin<2
        k=400;
        g=10;
    end
else %projection Mode
    U=in_U;   
end


% obtain feature Z
fprintf(' trainning ... \n')
Z = projectData(X',U,k,g);

end

