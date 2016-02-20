function [ parsed ] = parseData( files )
%PARSEDATA Summary of this function goes here
%   Detailed explanation goes here

parsed = struct;
nbFiles = numel(files);

pitch = zeros(nbFiles,1);
yaw = zeros(nbFiles,1);

parfor k=1:nbFiles
    [p,y] = parseFilename(files(k).name);
    pitch(k) = p;
    yaw(k) = y;
end

parsed.pitch = pitch;
parsed.yaw = yaw;
end

