function [ labels ] = parseData( files )
%PARSEDATA parse the given files (see parseFilename)
%   IN
%       files - the files to parse (dir function)
%   OUT
%       yaw   - yaw degree, offset by +90
%       pitch - pitch degree, offset by +10

nbFiles = numel(files);

yaw = zeros(nbFiles,1);
pitch = zeros(nbFiles,1);

parfor k=1:nbFiles
    [y,p] = parseFilename(files(k).name);
    yaw(k) = y;
    pitch(k) = p;
end

labels = struct;
labels.yaw = yaw;
labels.pitch = pitch; 

end

