%% initialization
clear;clc
files = dir('./training/*.png');
nbTraining = numel(files);
imNewSize = [32 32];
nbFeatures = prod(imNewSize);
trainingData = zeros(nbTraining,nbFeatures);
pitch = zeros(nbTraining,1);
yaw = zeros(nbTraining,1);
parfor k=1:nbTraining
    filename = files(k).name;
    trainingData(k,:) = preprocess(filename,imNewSize);
    [p y] = parseFilename(filename);
    pitch(k) = p;
    yaw(k) = y;
end
colMeans = mean(trainingData);
%perform pca
nbPC = 20;
[pc, score] = princomp(trainingData,'econ');
trainingData = score(:,1:nbPC);

%to use the native format of libsvm
trainingDataSparse = sparse(trainingData);
libsvmwrite('pitchPCA.train', pitch, trainingDataSparse);
libsvmwrite('yawPCA.train', yaw, trainingDataSparse);

[trainingData, scaleInfo] = scaleData(trainingData);

%% svm training

%only pca
yaw_model = svmtrain2(yaw, trainingData, '-g 0.00012207 -c 32768'); % C=8, gamma = .49e-6; 
pitch_model = svmtrain2(pitch, trainingData, '-g 0.0078125 -c 32');

%pca + sobel
%yaw_model = svmtrain2(yaw, trainingData, '-g 0.125 -c 8');
%pitch_model = svmtrain2(pitch, trainingData, '-g 0.0078125 -c 512');

%% save svm models for easier testing
head_pose_estimator = struct;
head_pose_estimator.pitch = pitch_model;
head_pose_estimator.yaw = yaw_model;
save('svm_model_pca.mat','head_pose_estimator')

%% test data
files2 = dir('./test/*.png'); %test files
nbTest = numel(files2);
testData = zeros(nbTest,nbFeatures);
parfor k=1:nbTest
    filename = files2(k).name;
    testData(k,:) = preprocess(filename,imNewSize);
end
testData = bsxfun(@minus, testData, colMeans); %scale according to column means of training set
testData = testData * pc(:,1:nbPC);
testData = scaleData(testData,scaleInfo);


%% perform prediction on test data
[yaw_pred, ~, ~] = svmpredict(zeros(nbTest,1), testData, yaw_model);
[pitch_pred, ~, ~] = svmpredict(zeros(nbTest,1), testData, pitch_model);
%[ pose_estimations, results ] = convertResults( yaw_pred, pitch_pred );

pred = [yaw_pred pitch_pred]


%% see results on training data
fprintf('\n\n')
[yaw_pred2, ~, ~] = svmpredict(yaw, trainingData, yaw_model);
[pitch_pred2, ~, ~] = svmpredict(pitch, trainingData, pitch_model);
%[ pose_estimations, results ] = convertResults( yaw_pred, pitch_pred );
pred2 = [yaw_pred2 pitch_pred2]
%display(results)