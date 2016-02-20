function [ data ] = invscaleData( scaled, settings )
%INVSCALEDATA inverts the scaling settings of scaled column data
%   see scaleData
data = mapminmax('reverse', scaled', settings);
data = data';
end

