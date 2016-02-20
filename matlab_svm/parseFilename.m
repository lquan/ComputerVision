function [ pitch, yaw ] = parseFilename( filename )
% parses the filename (including 3 letter extension) to the following
% where      pitch
%            yaw

pitch = 0;  % pitch -10 -5 0 5 10
yaw = 0;    % yaw -90 -45 -30 -20 -10 0 10 20 30 45 90

splitted = textscan(filename(1:end-4), '%s' , 'delimiter', '_');
splitted = splitted{:};

switch(splitted{2})
    case 'N' %nothing to do

    case 'PR'
        yaw = 0;
        switch(splitted{3})
            case 'D'
                pitch = -10;
            case 'SD'
                pitch = -5;
            case 'SU'
                pitch = 5;
            case 'U'
                pitch = 10;
        end
    case 'YR'
        pitch = 0;
        switch(splitted{3})
            case 'L90'
                yaw = -90;
            case 'L45'
                yaw = -45;
            case 'L30'
                yaw = -30;
            case 'L20'
                yaw = -20;
            case 'L10'
                yaw = -10;
                
            case 'R10'
                yaw = 10;
            case 'R20'
                yaw = 20;
            case 'R30'
                yaw = 30;
            case 'R45'
                yaw = 45;
            case 'R90'
                yaw = 90;
            otherwise
                error(['input not recognized. check filename: ' filename])
        end
    otherwise
        error(['input not recognized. check filename: ' filename])
end
end