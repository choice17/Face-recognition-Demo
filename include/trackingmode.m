function  trackingMD= trackingmode(trackingMD)
% operate private tracking mode
% return tracking model 
% INPUT  - trackingMD 
%==========initialize
    videoFrame= trackingMD.videoFrame;
    videoFrameGray = trackingMD.videoFrameGray;
    bboxPoints=trackingMD.bboxPoints;
    oldPoints=trackingMD.oldPoints;
    pointTracker=trackingMD.pointTracker;
%==========

        [xyPoints, isFound] = step(pointTracker, videoFrameGray);
        visiblePoints = xyPoints(isFound, :);
        oldInliers = oldPoints(isFound, :);
   
        numPts = size(visiblePoints, 1);

        if numPts >= 15
            % Estimate the geometric transformation between the old points
            % and the new points.
            [xform,visiblePoints] = estimateGeometricTransform(...
                oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

            % Apply the transformation to the bounding box.
            bboxPoints = transformPointsForward(xform, bboxPoints);
            visiblePoints = transformPointsForward(xform,visiblePoints);
            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);
             videoFrame = insertMarker(videoFrame, visiblePoints, '+', 'Color', 'yellow');
            
            % Display a bounding box around the face being tracked.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 6);

            % Display tracked points.
           

            % Reset the points.
            oldPoints = visiblePoints;
            setPoints(pointTracker, oldPoints);
            trackingMD.bboxPoints=bboxPoints;
            trackingMD.oldPoints=oldPoints;
        
        else
            trackingMD.bboxPoints=[];
            trackingMD.oldPoints=[];
            
        end
      %  
        trackingMD.videoFrame=videoFrame;
        trackingMD.numPts = numPts;
        
        trackingMD.pointTracker=pointTracker;
        
        
end