function [ pose_results , results] = headPoseEstimator( files )
%HEADPOSEESTIMATOR Summary of this function goes here
%   Detailed explanation goes here

load('svm_model_pca.mat');
pitch_estimator = head_pose_estimator.pitch;
yaw_estimator  = head_pose_estimator.yaw;

nb = numel(files);
pose_results = cell(nb,1);
%testData = zeros(nb,nbFeatures);
results = zeros(nb,2);

for k=1:numel(files)
    filename = files(k).name;
    testData = preprocess(filename,imNewSize); 
    testData = double(testData);
    testData = testData - colMeans; %scale according to column means of training set
    testData = testData * pc;            %project into PCA subspace
    testData = scaleData(testData,scaleInfo);      %perform scaling for SVM
    
    yaw_pred = svmpredict(0, testData, yaw_estimator);
    pitch_pred = svmpredict(0, testData, pitch_estimator);
    
    pose_estimation = struct;
    if (yaw_pred ~= 0)
        pose_estimation.direction = 'Y';
        pose_estimation.rotation = yaw_pred;
    else
        pose_estimation.direction = 'P';
        pose_estimation.rotation = pitch_pred;
    end
    results(k,:) = [yaw_pred pitch_pred];
    pose_results{k} = pose_estimation;
end

end



