function [x,y]=ASM_align_data_inverse(x,y,tform)
% Correct for rotation
rot = atan2(y,x);
rot = rot-tform.offsetr;
dist = sqrt(x.^2+y.^2);
x =dist.*cos(rot);
y =dist.*sin(rot);
x = x - tform.offsetx;
y = y - tform.offsety;
