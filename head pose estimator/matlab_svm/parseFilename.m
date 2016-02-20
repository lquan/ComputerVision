function [ yaw, pitch ] = parseFilename( filename )
% parses the filename (including 3 letter extension).
% if not recognized, pitch = yaw = 0
% we use an offset so that the values are positive for the LSSVM training
% 
%  IN
%    filename - the filename to parse
%  OUT
%    yaw    -  yaw degree (offset +90)
%    pitch  -  pitch degree (offset +10)

yaw = 0;    % yaw -90 -45 -30 -20 -10 0 10 20 30 45 90
pitch = 0;  % pitch -10 -5 0 5 10

splitted = textscan(filename(1:end-4), '%s' , 'delimiter', '_');
splitted = splitted{:};
if ( numel(splitted) >= 3 )
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
            %yaw = str2double(splitted{3}(2:end));
            %if (strcmp(splitted{3}(1), 'L'))
            %    yaw = -yaw;
            %end
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
                    %error(['input not recognized. check filename: ' filename])
            end
        otherwise
            %error(['input not recognized. check filename: ' filename])
    end
    yaw = yaw + 90;
    pitch = pitch + 10; % lssvm cannot work with positive values for classes
    
end

end