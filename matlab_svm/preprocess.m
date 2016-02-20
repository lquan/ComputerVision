function [ I ] = preprocess( filename, imNewSize, sobelFilter )
%PREPROCESS preprocess the data
if (nargin == 1), imNewSize = [32 32]; sobelFilter = false; end
if (nargin == 2), sobelFilter = false; end  

%I = rgb2gray(imread(filename));
%I = histeq(I);
%h = fspecial('sobel'); %horizontal sobel filter
%I = [ imfilter(I,h) imfilter(I,h') ];
%I = imresize(I,imNewSize);
%I = imlincomb(1.0, imfilter(I,h), 1.0, imfilter(I,h'));
%imshow(I)

I = imread(filename);
I = imresize(I,imNewSize);
I = rgb2gray(I);
I = histeq(I);

if (sobelFilter)
    h = fspecial('sobel'); %horizontal sobel filter
    I = [ imfilter(I,h); imfilter(I,h') ];   
end
%I = imresize(I,imNewSize);
I = I(:)';
end

