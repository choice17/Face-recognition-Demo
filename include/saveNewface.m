function list = saveNewface(imSize,fileformat)

prompt = 'Input className : ';
className = input(prompt,'s');
local = cd;
path = strcat('face\NewFace\',className);
mkdir(path);
cd(path);

trackingMD=[];

if nargin<1
imSize=[64 64];
fileformat = 'jpg';
end

% to initialize object 
% Create the face detector object.
trackingMD.faceDetector = vision.CascadeObjectDetector();
trackingMD.faceDetector.MergeThreshold = 10;
% Create the point tracker object.
trackingMD.pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
% Create the webcam object.
cam = webcam(1);
% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
savebox=zeros(4,2);
saveimg=zeros([frameSize(1) frameSize(2)]);


% for debug --------------------------------------
% saveimgF = zeros(frameSize); 
% ------------------------------------------------

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
%% start detect and tracking faces
runLoop = true;
trackingMD.numPts = 0;
frameCount = 0;
i=1;T=300;R=5;
N=T/R;t=0;

while runLoop && frameCount < 1000

    % Get the next frame.
    trackingMD.videoFrame = snapshot(cam);
    trackingMD.videoFrameGray = rgb2gray(trackingMD.videoFrame);
    
    %trackingMD.numPts
    rundetect = trackingMD.numPts < 10;
    
    switch rundetect || mod(t,N)==0
        % Detection mode.
       case 1 
            [trackingMD] = detectionmode(trackingMD);
            if mod(t,N)==0
                t=1;
                
            end
                 
       case 0
        % Tracking mode
        [trackingMD]=trackingmode(trackingMD);
       
        %for debug-----------------------------
        %saveimgF(:,:,:,i)=trackingMD.videoFrame;
        %---------------------------------------
        if ~isempty(trackingMD.bboxPoints)
        savebox(:,:,i)=trackingMD.bboxPoints;
        saveimg(:,:,i)=trackingMD.videoFrameGray;
        i=i+1;
        t=t+1;
        end
    end
        
    
    % Display the annotated video frame using the video player object.
    videoPlayer.Name = char(string(i));
    step(videoPlayer, trackingMD.videoFrame);
    if i > T 
        frameCount = 1000;
    end
    frameCount = frameCount +1;
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
    %control capturing period
   pause(0.05);
end

% Clean up.
clear cam; clear trackingMD;
   
   %save image for training
   for j=1:size(saveimg,3)
      facecrop = mycrop(saveimg(:,:,j),savebox(:,:,j));
      face = imresize(facecrop,[64 64]);
      imwrite(uint8(face),strcat(num2str(j),'.',fileformat)); 

   end
cd ..
list = cd;
cd(local);

end