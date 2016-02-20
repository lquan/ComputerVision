function [ pitch, yaw ] = parseFilename( filename )
% parses the filename (including 3 letter extension) to the following
% where      pitch
%            yaw

pitch = false(1,5);  % pitch -10 -5 0 5 10
yaw = false(1,11);    % yaw -90 -45 -30 -20 -10 0 10 20 30 45 90

splitted = textscan(filename(1:end-4), '%s' , 'delimiter', '_');
splitted = splitted{:};

switch(splitted{2})
    case 'N'
        pitch(3) = 1;
        yaw(6) = 1;
    case 'PR'
        yaw(6) = 1;
        switch(splitted{3})
            case 'D'
                pitch(1) = 1;
            case 'SD'
                pitch(2) = 1;
            case 'SU'
                pitch(4) = 1;
            case 'U'
                pitch(5) = 1;
        end
    case 'YR'
        pitch(3) = 1;
        switch(splitted{3})
            case 'L90'
                yaw(1) = 1;
            case 'L45'
                yaw(2) = 1;
            case 'L30'
                yaw(3) = 1;
            case 'L20'
                yaw(4) = 1;
            case 'L10'
                yaw(5) = 1;
                
            case 'R10'
                yaw(7) = 1;
            case 'R20'
                yaw(8) = 1;
            case 'R30'
                yaw(9) = 1;
            case 'R45'
                yaw(10) = 1;
            case 'R90'
                yaw(11) = 1;
            otherwise
                error(['input not recognized. check filename: ' filename])
        end
    otherwise
        error(['input not recognized. check filename: ' filename])
end
end