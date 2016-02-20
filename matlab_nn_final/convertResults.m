function [ pose_estimations, results ] = convertResults( yaw_predictions, pitch_predictions )

% convert the predictions to the poses
yaw_idx = [ -90 -45 -30 -20 -10 0 10 20 30 45 90 ];
pitch_idx = [-10 -5 0 5 10];
n = size(yaw_predictions,2);
pose_estimations = cell(n,1);
results = zeros(n,2);          %for debugging

neutralYawIdx = find(yaw_idx == 0); %yaw has priority
for i=1:n
   [~,idx] = max(yaw_predictions(:,i));
   direction = 'Y';  rotation = yaw_idx(idx); results(i,1) = rotation;
   if (idx == neutralYawIdx) 
       [~,idx] = max(pitch_predictions(:,i));
       direction = 'P'; rotation = pitch_idx(idx); results(i,2) = rotation;
   end
   pose_estimations{i} = struct('direction', direction, 'rotation', rotation);
   
   %figure, imshow(files2(i).name); hold on; title([direction ': ' num2str(rotation) ' degree']) 
end

end

