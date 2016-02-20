function [ scaled, settings ] = scaleData( data, settings )
%SCALEDATA scales the columns of data to [-1,1]
%   uses Neural Network toolbox mapminmax command
% also see invscaleData

if (nargin == 2)
    scaled = mapminmax('apply', data', settings); 
else
    [scaled,settings] = mapminmax(data');
end

scaled = scaled';

