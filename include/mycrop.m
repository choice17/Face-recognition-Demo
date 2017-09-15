function img_out = mycrop(videoframe,bboxPoints)
% mycrop(videoframe,bboxPoints) return crop image with poly box points
% INPUT : videoframe with size[imh imw rgb] or size[imh imw] for gray color
%         bboxPoints are 4 by 2 matrix for corner points

%shift image coordinate to center with 2 corners as reference
[h,w,re] = size(videoframe);
p1 = [w/2 -h/2; -w/2 -h/2; -w/2 h/2];
box = [bboxPoints(:,1)-w/2 bboxPoints(:,2)-h/2]; 
ref_points = [p1;box];

%rotate the box around center
h1 = bboxPoints(2,2)-bboxPoints(1,2);
w1 = bboxPoints(2,1)-bboxPoints(1,1);
ang = atan(h1/w1);

r= [cos(ang) -sin(ang); sin(ang) cos(ang)];
pr = ref_points*r;

%shift the points through the ref rotated points
nbox = pr(4:end,:);
if ang<0
    nbox = [nbox(:,1)-pr(3,1) nbox(:,2)-pr(2,2)];
else 
    nbox = [nbox(:,1)-pr(2,1) nbox(:,2)-pr(1,2)];
end
h_w = abs([(nbox(1,2)-nbox(3,2)) (nbox(1,1)-nbox(2,1))]); 


img_out = imcrop(imrotate(videoframe,ang*180/pi),[nbox(1,:) h_w]);

%for debug: insert shape into videoframe=====================
%b = bboxPoints';
%b = b(:)';
%videoframe = insertShape(videoframe, 'Polygon', b, 'LineWidth', 6);
            


end 

%{ 
METHOD2
function img_out = mycrop(videoframe,bboxPoints)
% mycrop(videoframe,bboxPoints) return crop image with poly box points
% INPUT : videoframe with size[imh imw rgb] or size[imh imw] for gray color
%         bboxPoints are 4 by 2 matrix box points

if bboxPoints(1,2)== bboxPoints(2,2)
        img_rotate=videoframe;
        box2 = bboxPoints;
else
    
    %to crop and localize the face
    box1 = min(bboxPoints);    
    widthbox =  max(bboxPoints) - box1;
    img_crop = imcrop(videoframe,[box1 widthbox]);

    
    %rotate the face to right orientation
    h = bboxPoints(2,2)-bboxPoints(1,2);
    w = bboxPoints(2,1)-bboxPoints(1,1);
    angle = atan(h/w);
    
    %calc new box position and width(assumed square box)
    len = sqrt((bboxPoints(1,1)-bboxPoints(2,1))^2+ ...
        (bboxPoints(1,2)-bboxPoints(2,2))^2) - 8;
    h2 = abs(widthbox(1,2)*sin(angle));
    box2 = [h2 h2 len len];
    
    img_rotate= imrotate(img_crop,angle*180/pi);
end
    
    img_out = imcrop(img_rotate,box2);

end
%}
%%
%bb =bbb';
%  bb = bb(:)';
%b = insertShape(img_out, 'Polygon', bb, 'LineWidth', 3);
 % b = insertShape(trackingMD.videoFrame, 'Polygon', box, 'LineWidth', 3);
%{
METHOD3

 
[vh, vw, vc]= size(videoframe);
videoframe = videoframe;
h = bboxPoints(2,2)-bboxPoints(1,2);
w = bboxPoints(2,1)-bboxPoints(1,1);
angle = atan(h/w);
img_out = imrotate(videoframe,angle*180/pi);
[rh,rw,rc] = size(img_out);
dw = rw/2-vw/2; dh = rh/2-vh/2;
box =
%r= [cos(angle) -sin(angle); sin(angle) cos(angle)];
%box = bboxPoints*r;
%bbb=box;
%h1 = abs(box(1,1)-box(2,1));
%box = [box(1,1) box(1,2)+abs(vw*sin(angle)) h1 h1]; 
%box(:,1) = box(:,1)+abs(vw*sin(angle));
%box(:,2) = box(:,2)+abs(vw*sin(angle)); 

 
 %}
