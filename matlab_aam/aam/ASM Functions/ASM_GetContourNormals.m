function [nx,ny]=ASM_GetContourNormals(xt,yt)
% This function calculates the normals, of the contour points
% using the neighbouring points of each contour point, and 
% forward an backward differences on the end points
%
% [nx,ny]=GetContourNormals(xt,yt)

% Derivatives of contour
dx=[xt(2)-xt(1) (xt(3:end)-xt(1:end-2))/2 xt(end)-xt(end-1)];
dy=[yt(2)-yt(1) (yt(3:end)-yt(1:end-2))/2 yt(end)-yt(end-1)];
% Normals of contourpoints
l=sqrt(dx.^2+dy.^2);
nx = -dy./l; 
ny =  dx./l;
