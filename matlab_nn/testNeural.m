
%% initialisation vars
files = dir('./training/*.png'); % training data
nbTraining = numel(files);
imNewSize = [32 32];  %resize dimensions
nbFeatures = prod(imNewSize);  

files2 = dir('./test/*.png'); %test files
nbTest = numel(files2);

%% process the training data
A = zeros(nbFeatures,nbTraining);
%A2 = zeros(nbFeatures,nbTraining);
pitch = zeros(5,nbTraining);
yaw = zeros(11,nbTraining);
parfor k=1:nbTraining
    filename = files(k).name;
    I = preprocess(filename, imNewSize);  
    A(:,k) = double(I(:));

    [p, y] = parseFilename(filename);
    pitch(:,k) = p;
    yaw(:,k) = y; 
end

%% process the test data
B = zeros(nbFeatures,nbTest);
%B2 = zeros(nbFeatures,nbTest);
parfor k=1:nbTest
    filename = files2(k).name;
    I = preprocess(filename, imNewSize); 
    B(:,k) = double(I(:));
end
clear I J p y filename k  %cleanup of unnecessary vars


%% neural network training
nprYaw;
nprPitch;

%% now use the NN to predict on the test set
yaw_predictions = net1(B);
pitch_predictions = net2(B);
[pose_estimations, results] = convertResults(yaw_predictions,pitch_predictions);

display(results);


%% check again on the training set
%yaw_predictions2 = net1(A);
%pitch_predictions2 = net2(A);
%[~, results2] = convertResults(yaw_predictions2,pitch_predictions2);

%display(results2);

