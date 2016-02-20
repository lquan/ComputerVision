
%% initialization
clear;clc; %matlabpool
testFiles = dir('./test/*.png');
fid = fopen('results.txt','a');  % we will write some debugging information
fprintf(fid,'\n\n *** script run %s', date);

%% runs the head pose estimator on the test files and outputs the results
trainingOn = false;  %set true if you want training
fprintf('\nMaking head pose predictions...\n')
[pose_results, results, hpe] = headPoseEstimator(testFiles, trainingOn);
fprintf(fid,'\n\nyaw training set accuracy: %f\n', hpe.yawAcc);
fprintf(fid,'pitch training set accuracy: %f\n', hpe.pitchAcc);
fprintf(fid,'total training set accuracy: %f\n', hpe.totalAcc);
display(results);

% if you have labeled test files
labels = parseData(testFiles);

%nb = numel(testFiles);
%testAccuracyYaw = sum(labels.yaw-90 == results(:,1))/nb;
%testAccuracyPitch = sum(labels.pitch-10  == results(:,2))/nb;
%testTotalAccuracy = sum(labels.yaw-90 == results(:,1) & labels.pitch-10  == results(:,2))/nb;

%fprintf('\n\nyaw test set accuracy: %f\n', testAccuracyYaw);
%fprintf('pitch test set accuracy: %f\n', testAccuracyPitch);
%fprintf('total test set accuracy: %f\n', testTotalAccuracy);


%% shows the image one for one and its results
% warning off
% for k=1:numel(testFiles)
%   filename = testFiles(k).name;
%   imshow(filename,'Border','tight');
%   fprintf('%s was estimated as: %s %d\npress key for next image (ctrl-c to abort)\n\n', ...
%            filename, pose_results{k}.direction, pose_results{k}.rotation);
%   pause
% end


%% face recognition system
fprintf('\nMaking face predictions...\n')
faceResults = faceRecognizer(testFiles);
[val,ind] = min(faceResults);
testLabels = [ 1 1 1 2 2 2 2 3 3 3 3 3 4 4 5 5 5 5 5 5]; %correct labels, only for prediction accuracy 
faceAcc = sum(ind == testLabels)/ numel(testLabels);
display(faceResults);
fprintf(fid,'\nface recognition accuracy: %f\n', faceAcc);


%% close the file
fprintf(fid,'\n***');
fclose(fid);
