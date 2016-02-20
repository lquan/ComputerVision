function [ out ] = loadData(files, imNewSize)
%LOADDATA loads the given files, preprocess into matrix 
if (nargin < 2), imNewSize = [32 32]; end;

nbFiles = numel(files);
nbFeatures = prod(imNewSize);
out = zeros(nbFiles,nbFeatures);

parfor k=1:nbFiles
    filename = files(k).name;
    
    I = rgb2gray(imresize(imread(filename), imNewSize));
    I = histeq(I);

    %if (sobelFilter)
    %    h = fspecial('sobel'); %horizontal sobel filter
    %    I = [ imfilter(I,h); imfilter(I,h') ];   
    %end
    out(k,:) = double(I(:)');
end

end