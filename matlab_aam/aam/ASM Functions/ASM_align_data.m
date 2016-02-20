function [x,y,tform]=ASM_align_data(x,y)
% Aligns the contours positions, center the data and remove rotation

% Center data to remove translation 
offsetx = -mean(x);
offsety = -mean(y);
x = x + offsetx;
y = y + offsety;

% Correct for rotation
% Calculate angle to center of all points
rot = atan2(y,x);
% Subtract the mean angle
offsetr=-mean(rot(1:round(end/2)));
rot = rot+offsetr;
% Make the new points, which all have the same rotation
dist = sqrt(x.^2+y.^2);
x =dist.*cos(rot);
y =dist.*sin(rot);
% Store transformation object
tform.offsetx=offsetx;
tform.offsety=offsety;
tform.offsetr=offsetr;

