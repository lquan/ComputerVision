function [ pose_estimations, results ] = convertResults( yaw_predictions, pitch_predictions )
%converts the output of SVM to pose estimation

n = numel(yaw_predictions);
% convert the predictions to the poses
yaw_idx = [-90 -45 -30 -20 -10 0 10 20 30 45 90]';
pitch_idx = [-10 -5 0 5 10]';

pose_estimations = cell(n,1);
results = zeros(n,2);          %for debugging

results(:,1) = yaw_idx(yaw_predictions+6);   %offset because of indexing
results(:,2) = pitch_idx(pitch_predictions+3); %offset because of indexing

end
