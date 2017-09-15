clc;
clear all;
close all;
%%
% Create a cascade detector object.
%figure('Name', 'My Custom Preview Window'); 
%uicontrol('String', 'Close', 'Callback', 'close(gcf)');  
vid=videoinput('winvideo', 1, 'YUY2_640x480');
vid.ReturnedColorspace = 'rgb';
vidRes = get(vid, 'VideoResolution');

% image width
imWidth = vidRes(1);
% image height
imHeight = vidRes(2);
% number of bands of our image (should be 3 because it's RGB)
nBands = get(vid, 'NumberOfBands');
% create an empty image container and show it on axPreview
hImage = image(zeros(vidRes(2), vidRes(1), nBands)  );
hold on;
preview(vid,hImage);
%%
%figure('Name', 'face detect'); 
%uicontrol('String', 'Close', 'Callback', 'close(gcf)');  
faceDetector = vision.CascadeObjectDetector();

t = 0.2;
i=0;
% Read a video frame and run the face detector.
while (1)
   
videoFrame      = getsnapshot(vid);
tic
bbox            = step(faceDetector, videoFrame);
%Draw the returned bounding box around the detected face.
if (size(bbox,1) == 1)
fprintf('\nface detected counter i = %d\n',i);
videoFrame = insertShape(videoFrame, 'Rectangle', bbox);
figure(2);
imshow(videoFrame); 
bboxPoints = bbox2points(bbox(1, :));
end
i=i+1;
t = toc;
end
% Convert the first box into a list of 4 points
% This is needed to be able to visualize the rotation of the object.

