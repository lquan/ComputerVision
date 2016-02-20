function [ hpe ] = trainHeadPoseEstimator( trainingFiles, nbPC )
%TRAINHEADPOSEESTIMATOR trains the head pose estimator
% IN
%    trainingFiles - the training files (use dir function)
%    nbPC - number of principal components to use (default 20)
% OUT
%    hpe - the head pose estimator structure containing all the information
%          to make head pose predictions. 
%          this includes the following:
%             hpe.colMeans - col means for centering of pca projection
%             hpe.princomp - principal components
%             hpe.yaw      - yaw model
%             hpe.pitch    - pitch model

trainingData = loadData(trainingFiles);
colMeans = mean(trainingData);
labels = parseData(trainingFiles);

% perform pca
if (nargin < 2), nbPC = 20; end;
[pc, score] = princomp(trainingData,'econ');

trainingData = score(:,1:nbPC);

% svm training
type = 'c'; %we use classification
%[Yp1,alpha1,b,gam,sig2_1,yawModel]
[yawPredictions,~,~,~,~,yawModel] = lssvm(trainingData, labels.yaw, type);
[pitchPredictions,~,~,~,~,pitchModel] = lssvm(trainingData, labels.pitch, type);

% calculate training accuracy
nb = numel(trainingFiles);
yawAcc = sum(labels.yaw==yawPredictions)/nb;
pitchAcc = sum(labels.pitch==pitchPredictions)/nb;
totalAcc = sum(labels.yaw==yawPredictions & labels.pitch==pitchPredictions)/nb;

% struct containing all the information for the head pose estimator
hpe = struct;
hpe.yaw = yawModel;
hpe.pitch = pitchModel;
hpe.colMeans = colMeans;
hpe.princomp = pc(:,1:nbPC);
hpe.yawAcc = yawAcc;
hpe.pitchAcc = pitchAcc;
hpe.totalAcc = totalAcc;
%hpe.princompInfo = cumsum(latent)/sum(latent); %this helps choosing the nb of pc

end

