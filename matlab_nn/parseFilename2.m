function [ pitch, yaw ] = parseFilename2( filename )
% parses the filename (including 3 letter extension) to the following
% where      pitch   
%            yaw     

pitch = zeros(1,5);  % pitch -10 -5 0 5 10
yaw = zeros(1,8);    % yaw -90 -45 0 10 20 30 45 90

splitted = textscan(filename(1:end-4), '%s' , 'delimiter', '_');
splitted = splitted{:};
    switch(splitted{2})
        case 'N'
            pitch(3) = 1;
            yaw(3) = 1;
        case 'PR'
            yaw(3) = 1;
            switch(splitted{3})
                case 'D'
                    pitch(1) = 1;
                case 'SD'
                    pitch(2) = 1;
                case 'SU'
                    pitch(3) = 1;  
                case 'U'
                    pitch(4) = 1;
            end
        case 'YR'
            pitch(3) = 1;
            switch(splitted{3})
                case 'L90'
                    yaw(1) = 1;
                case 'L45'
                    yaw(2) = 1;
                case 'R10'
                    yaw(4) = 1;
                case 'R20'
                    yaw(5) = 1;
                case 'R30'
                    yaw(6) = 1;
                case 'R45'
                    yaw(7) = 1;   
                case 'R90'
                    yaw(8) = 1;
                otherwise
                    error('input not recognized')
            end
        otherwise
            error('input not recognized')
    end
end