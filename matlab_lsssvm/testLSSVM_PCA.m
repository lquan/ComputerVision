%% runs the head pose estimator on the test files and outputs the results
clear;clc
testFiles = dir('./testlabeled/*.png');
[pose_results, results, hpe] = headPoseEstimator(testFiles, false);
fprintf('\n\nyaw training set accuracy: %f\n', hpe.yawAcc);
fprintf('pitch training set accuracy: %f\n', hpe.pitchAcc);
fprintf('total training set accuracy: %f\n', hpe.totalAcc);
display(results);

labels = parseData(testFiles);

nb = numel(testFiles);
testAccuracyYaw = sum(labels.yaw-90 == results(:,1))/nb
testAccuracyPitch = sum(labels.pitch-10  == results(:,2))/nb
testTotalAccuracy = sum(labels.yaw-90 == results(:,1) & labels.pitch-10  == results(:,2))/nb

%% shows the image one for one and its results
% warning off
% for k=1:numel(testFiles)
%   filename = testFiles(k).name;
%   imshow(filename,'Border','tight');
%   fprintf('%s was estimated as: %s %d\npress key for next image (ctrl-c to abort)\n\n', ...
%            filename, pose_results{k}.direction, pose_results{k}.rotation);
%   pause
% end
