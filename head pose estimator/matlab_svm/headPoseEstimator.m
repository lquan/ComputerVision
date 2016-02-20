function [ pose_results, results, hpe ] = headPoseEstimator( testFiles, trainingOn )
%HEADPOSEESTIMATOR head pose estimator
% IN
%    testFiles  - the test filenames (use dir function)
%    trainingOn - boolean controlling whether we want an explicit training
%                 of our SVM (default: false). note that training is always
%                 performed if there are no existing models found
% OUT
%    pose_results - the cell array according the specifications 
%                       (e.g.
%                           pose_results{1}.direction= ... and 
%                           pose_results{k}.rotation = ...
%                       )
%    results      - matrix with the predictions (yaw, pitch) for quick debugging
%    hpe          - the complete head pose estimation system 
%                           (see traingHeadPoseEstimator)

if (nargin < 2), trainingOn = false; end;
%% check whether training flag is on or has not already been performed
poseEstimatorFile = './poseEstimator.mat';
if (trainingOn || ~exist(poseEstimatorFile, 'file')) 
    trainingFiles = dir('./training/*.png');
    hpe = trainHeadPoseEstimator(trainingFiles);
    save(poseEstimatorFile, 'hpe');
end

load(poseEstimatorFile, 'hpe');
%% load the test data
testData = loadData(testFiles);
testData = bsxfun(@minus, testData, hpe.colMeans); %center according to column means of training set
testData = testData * hpe.princomp;                %project into PCA subspace

%% perform prediction on test data
yawPredictions = simlssvm(hpe.yaw, testData);
pitchPredictions = simlssvm(hpe.pitch, testData);
%% offset correction
yawPredictions = yawPredictions - 90;         
pitchPredictions = pitchPredictions - 10;

%% create the output cell array according the specifications
% the predictions are ordered alphabetically according to file name
nbTest = numel(testFiles);
pose_results = cell(nbTest,1);
parfor k=1:nbTest;
    %yaw predictions are better in general so they have precedence
    if (yawPredictions(k) ~= 0)
        pose_results{k}.direction = 'Y';
        pose_results{k}.rotation = yawPredictions(k);
    else
        pose_results{k}.direction = 'P';
        pose_results{k}.rotation = pitchPredictions(k);
    end
end

% we also provide a simple matrix result for quick debugging
results = [yawPredictions, pitchPredictions];

end