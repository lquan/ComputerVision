function greyvector=AAM_Appearance2Vector(I,x,y,base_points,ObjectPixels,texturesize)
% Transform the hands images first into the mean texture image, and than
% transform the image into a vector
%
% greyvector=Appearance2Vector(base_points,x,y, ObjectPixels,texturesize)
%
%
warning('off','Images:cp2tform:foldOverTriangles');

% The input image coordinates of a training set
input_points = [x(:) y(:)];

% Make the transformation structure, note that x and y are switched
% because Matlab uses the second dimensions as x and first as y.
% Piecewise-Linear 
xy=[input_points(:,2) input_points(:,1)];
uv=[base_points(:,2) base_points(:,1)];

% Remove control points which give folded over triangles with cp2tform
[xy uv]=PreProcessCp2tform(xy,uv);
trans_prj = cp2tform(xy,uv,'piecewise linear');

% Transform the image into the default texture image
J = imtransform(I,trans_prj,'Xdata',[1 texturesize(1)],'YData',[1 texturesize(2)],'XYscale',1);

J(isnan(J))=0;

% Store the transformed texture as a vector
if(size(I,3)==1)
    greyvector=J(ObjectPixels);
else
    Jr=J(:,:,1); Jg=J(:,:,2); Jb=J(:,:,3);
    greyvector=[Jr(ObjectPixels);Jg(ObjectPixels);Jb(ObjectPixels)];
end



