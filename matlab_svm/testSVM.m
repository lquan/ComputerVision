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


%to use the native format of libsvm
trainingDataSparse = sparse(trainingData);
libsvmwrite('pitch.train', pitch, trainingDataSparse);
libsvmwrite('yaw.train', yaw, trainingDataSparse);

%scale the training data and save the scaling info
[trainingData, scaleInfo] = scaleData(trainingData);

%% svm training
%parameters obtained by grid search via easy.py (see libsvm manual)
yaw_model = svmtrain2(yaw, trainingData, '-g 0.000488 -c 8'); % C=8, gamma = .49e-6; 
pitch_model = svmtrain2(pitch, trainingData, '-g 3.0518e-5 -c 2048');

%temp = [data yaw];
%save('yaw.txt','temp', '-ascii')
%temp = [data pitch];
%save('pitch.txt','temp', '-ascii')
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

testData = scaleData(testData,scaleInfo);


%% perform prediction on test data
[yaw_pred, ~, ~] = svmpredict(zeros(nbTest,1), testData, yaw_model);
[pitch_pred, ~, ~] = svmpredict(zeros(nbTest,1), testData, pitch_model);
[ pose_estimationsTest, results1 ] = convertResults( yaw_pred, pitch_pred );

display(results1)

display('\n\n')
%see results on training data
[yaw_pred, ~, ~] = svmpredict(yaw, trainingData, yaw_model);
[pitch_pred, ~, ~] = svmpredict(pitch, trainingData, pitch_model);
[ pose_estimationsTraining, results2 ] = convertResults( yaw_pred, pitch_pred );

display(results2)