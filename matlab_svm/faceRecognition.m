%% init
clear;clc
imSize = [32 32];          %image rescaling size
nbFeatures = prod(imSize); %length of feature vector

%% training data
trainingFiles = dir('./training/bs*N_N*.png');
nbTraining = numel(trainingFiles);
trainingData = zeros(nbTraining,nbFeatures);
parfor k=1:nbTraining
   trainingData(k,:) = preprocess(trainingFiles(k).name, imSize);
end

%% eigenface (PCA analysis)
mean_face = mean(trainingData,1);
[pc,score,latent] = princomp(trainingData,'econ'); %normalization is performed internally

nbPC = 20; %can be chosen via (e.g. 98%) %cumsum(latent)/sum(latent)
score = score(:,1:nbPC); % our original observations in projection space
pc = pc(:,1:nbPC);       % principal components (i.e. eigenfaces)

% plot first four eigenfaces
%for k=1:4
%    figure
%    eigenface = reshape(pc(:,k),imSize);     % Reshape into 2D array
%    imagesc(eigenface); % Display as image scaled 0-255
%    colormap(gray(256))
%end

%% our database of known images projected in eigenface subspace
databaseFiles = dir('./neutral_test/bs*N_N*.png');
nbDatabase = numel(databaseFiles);
database = zeros(nbDatabase,nbFeatures);
parfor k=1:nbDatabase
   database(k,:) = preprocess(databaseFiles(k).name, imSize);
end
database = bsxfun(@minus, database, mean_face);
database = database * pc;
labels = (1:nbDatabase)'; %labels in alphabetic order
[database, scaleInfo] = scaleData(database);
face_recognizer = svmtrain2(labels, database);

%% test unknown images
testFiles = dir('./test/*.png');
nbTest = numel(testFiles);

testImages = zeros(nbTest,nbFeatures);
parfor k=1:nbTest
    testImages(k,:) = preprocess(testFiles(k).name, imSize);
end
testImages = bsxfun(@minus, testImages, mean_face);
testImages = testImages * pc;

% using euclidian/mahalanobis distance


% using svm
[Euc_dist_min , Recognized_index] = min(Euc_dist);
OutputName = strcat(int2str(Recognized_index),'.jpg');

testImages = scaleData(testImages, scaleInfo);

testLabels = [ 1 1 1 2 2 2 2 3 3 3 3 3 4 4 5 5 5 5 5 5]'; %correct labels, only for prediction accuracy 
[predictions] = svmpredict(testLabels, testImages, face_recognizer);



