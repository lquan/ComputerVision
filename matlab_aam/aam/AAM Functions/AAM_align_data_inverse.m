function [x,y]=AAM_align_data_inverse(x,y,tform)

tform.offsets=sqrt( tform.offsetsx^2+tform.offsetsy^2);
tform.offsetr=atan2(tform.offsetsy  ,tform.offsetsx);


% Correct for rotation
rot = atan2(y,x);
rot = rot-tform.offsetr;
dist = sqrt(x.^2+y.^2);

x =dist.*cos(rot);
y =dist.*sin(rot);

x = x / tform.offsets;
y = y / tform.offsets;

x = x - tform.offsetx;
y = y - tform.offsety;
