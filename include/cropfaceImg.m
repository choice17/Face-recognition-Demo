function [x,bbox]=cropfaceImg(inX)

imageFrame = inX;
faceDetector = vision.CascadeObjectDetector();
faceDetector.MergeThreshold=8;
% Read a frame and run the face detector.

bbox         = step(faceDetector, imageFrame);
% Crop the returned bounding box around the detected face.

if ~isempty(bbox)
    x=imcrop(imageFrame,bbox(1,1:4));
else
    x=inX;
end
end