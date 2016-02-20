function [ I ] = preprocess( filename, imNewSize )
%PREPROCESS Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2, imNewSize = [32 32]; end  %resize dimensions

I = imread(filename);
I = imresize(I,imNewSize);
I = rgb2gray(I);
%h = fspecial('sobel'); %horizontal sobel filter
%I = imfilter(I,h);
I = histeq(I);
% imshow(I);


end

