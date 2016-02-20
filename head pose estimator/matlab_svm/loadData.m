function [ out ] = loadData(files, imNewSize)
%LOADDATA loads the given files, preprocess into matrix 
% the preprocessing consists of following steps:
%  1)resizing
%  2)grayscale conversion
%  3)histogram equalization
%
%  IN  - files (use dir function)
%       imNewSize  - the size to which images are rescaled (default (32x32)
%  OUT - matrix containing the data (rows are observations)
%

if (nargin < 2), imNewSize = [32 32]; end;

nbFiles = numel(files);
nbFeatures = prod(imNewSize);
out = zeros(nbFiles,nbFeatures);

parfor k=1:nbFiles
    I = rgb2gray(imresize(imread(files(k).name), imNewSize));
    I = histeq(I);

    %if (sobelFilter)
    %    h = fspecial('sobel'); %horizontal sobel filter
    %    I = [ imfilter(I,h); imfilter(I,h') ];   
    %end
    out(k,:) = double(I(:)');
end

end