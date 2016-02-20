function [x,y,tform]=AAM_align_data(x,y,xb,yb)
% Remove rotation and translation and scale : Procrustes analysis 

% Center data to remove translation 
offsetx = -mean(x);
offsety = -mean(y);
x = x + offsetx;
y = y + offsety;

offsetxb = -mean(xb);
offsetyb = -mean(yb);
xb = xb + offsetxb;
yb = yb + offsetyb;

%  Set scaling to base example
d = mean(sqrt(x.^2 + y.^2));
db = mean(sqrt(xb.^2 + yb.^2));
offsets=(db/d);
x = x*offsets;
y = y*offsets;

% Correct for rotation
% Calculate angle to center of all points
rot = atan2(y,x);
rotb = atan2(yb,xb);

% Subtract the mean angle
offsetr=-mean(rot-rotb);
rot = rot+offsetr;

% Make the new points, which all have the same rotation
dist = sqrt(x.^2+y.^2);
x =dist.*cos(rot);
y =dist.*sin(rot);

% Store transformation object
tform.offsetx=offsetx;
tform.offsety=offsety;
tform.offsetr=offsetr;
tform.offsets=offsets;
tform.offsetsx=offsets*cos(offsetr);
tform.offsetsy=offsets*sin(offsetr);
