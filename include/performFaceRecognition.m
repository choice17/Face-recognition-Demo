load data/predictMdl.mat;
clear cam;

%Threshold confident value from SVM
%Number of agreement of consecutive prediction 
%numPts needed for tracking 
%face detector Threshold

Threshold = -0.040;
N = 5;
numPts =15;
trackingMD=[];
% Create the face detector object.
trackingMD.faceDetector = vision.CascadeObjectDetector();
trackingMD.faceDetector.MergeThreshold = 6;




% Create the point tracker object.
trackingMD.pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% Create the webcam object.
cam = webcam(1);
% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
savebox=zeros(4,2);
saveimg=zeros([frameSize(1) frameSize(2)]);
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
%% start detect and tracking faces
runLoop = true;
trackingMD.numPts = 0;
frameCount = 0;
i=0;
confidentR=0;
yX=[];
while runLoop && frameCount < 1000
    nX=[];
    % Get the next frame.
    trackingMD.videoFrame = snapshot(cam);
    trackingMD.videoFrameGray = rgb2gray(trackingMD.videoFrame);
    
    %trackingMD.numPts
    if trackingMD.numPts < numPts %|| mod(frameCount,150)==0
        % Detection mode.
        [trackingMD] = detectionmode(trackingMD);
     
    else
        % Tracking mode
        [trackingMD]=trackingmode(trackingMD);
        
        
        %for debug-----------------------------
        %saveimgF(:,:,:,i)=trackingMD.videoFrame;
        %---------------------------------------
        if ~isempty(trackingMD.bboxPoints)
            i=i+1;
        savebox(:,:,i)=trackingMD.bboxPoints;
        saveimg(:,:,i)=trackingMD.videoFrameGray;
        end
    end
    
    % Display the annotated video frame using the video player object.
    step(videoPlayer, trackingMD.videoFrame);
   
    % Prediction
    if i == N
        i=0;
        for j=1:N
        imgc = mycrop(saveimg(:,:,j),savebox(:,:,j));
        img = imresize(imgc,[64 64]);
        img = img(:);
        nX = [nX img];
        end
        
        %predict value
        nX = featureNormalize(nX);
        [Z] = featureExtractPCA(nX,classMdl.K,classMdl.G,classMdl.U);
        [predictclass,confident] = predict(Mdl,Z);
        confidentR = mean(confident(:,mode(predictclass+1)));
        yX=[yX;confidentR];
        
        %prediction display
        if confidentR>Threshold
        figure(10);subplot 121;imshow(uint8(imgc));xlabel(num2str(confidentR));
        title('Query Image');
        subplot 122;displayData(classMdl.cImg(:,median(predictclass)+1)');
        classnum = strcat('Predict Class: ',string(median(predictclass)+1));
        title(classnum);
        end
        
    end
    frameCount = frameCount +1;
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
    %control capturing period
   %pause(0.05);
end


%[predclass] = predict(Mdl,Zt);
%accuracy = sum(predclass==tsty')/length(tsty);