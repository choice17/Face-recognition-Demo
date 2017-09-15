function [trackingMD] = detectionmode(trackingMD)
        
       
        bbox = trackingMD.faceDetector.step(trackingMD.videoFrameGray);
      
        if ~isempty(bbox) 
            if bbox(1,3) > 100
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(trackingMD.videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(trackingMD.pointTracker);
            initialize(trackingMD.pointTracker, xyPoints, trackingMD.videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            trackingMD.videoFrame = insertShape(trackingMD.videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);

            % Display detected corners.
            %videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
            else 
                bboxPoints=[];oldPoints=[];numPts=0;
            end
        else
            bboxPoints=[];oldPoints=[];numPts=0;
        end
        
        %trackingMD.videoFrame=videoFrame;
        %trackingMD.videoFrameGray=videoFrameGray;
        trackingMD.bboxPoints=bboxPoints;
        trackingMD.oldPoints=oldPoints;
        %trackingMD.pointTracker=pointTracker;
        trackingMD.numPts=numPts;  %#ok<*STRNU>
      
end