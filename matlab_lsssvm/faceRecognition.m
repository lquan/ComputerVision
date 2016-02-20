%% init
clear;clc; imSize = [64, 64];

%% training data
trainingFiles = dir('./training/bs*N_N*.png');
trainingData = loadData(trainingFiles, imSize);

%% eigenface (PCA analysis)
meanFace = mean(trainingData,1);
[pc,score,latent] = princomp(trainingData,'econ'); %normalization is performed internally

nbPC = 20; %can be chosen via (e.g. 98%) %cumsum(latent)/sum(latent)
score = score(:,1:nbPC); % our original observations in projection space
pc = pc(:,1:nbPC);       % principal components (i.e. eigenfaces)

%%plot first four eigenfaces
%for k=1:4
%    figure
%    eigenface = reshape(pc(:,k),imSize);     % Reshape into 2D array
%    imagesc(eigenface); % Display as image scaled 0-255
%    colormap(gray(256))
%end

%% our database of known images projected in eigenface subspace
databaseFiles = dir('./neutral_test/bs*N_N*.png');
database = loadData(databaseFiles, imSize);
database = bsxfun(@minus, database, meanFace);
database = database * pc;
%labels = (1:numel(databaseFiles))'; %labels in alphabetic order
%face_recognizer = svmtrain2(labels, database);
%model = initlssvm(database,labels,'classifier',[],[],'RBF_kernel');
%model = tunelssvm(model,'simplex','leaveoneoutlssvm',{'misclass'},'code_OneVsAll');
%model = trainlssvm(model);

%[facePredictions,~,~,~,~,faceRecognizer] = lssvm(database, labels, 'c');

%% test unknown images
testFiles = dir('./test/*.png');
testImages = loadData(testFiles, imSize);
testImages = bsxfun(@minus, testImages, meanFace);
testImages = testImages * pc;

%testPredictions = simlssvm(model, testImages);
%testImages = scaleData(testImages, scaleInfo);
%[predictions] = svmpredict(testLabels, testImages, face_recognizer);

%% calculate dissimilarity scores using euclidian distance 
% (mahalonibis should be better)
nbDatabase = numel(databaseFiles);
nbTest = numel(testFiles);
result = zeros(nbDatabase,nbTest);  % 5 x 20
for p = 1:nbTest
     %we loop through each test images and compare to each in the database
     testImage = repmat(testImages(p,:), [nbDatabase,1]);
     diff = testImage - database;      %difference
     diff = sqrt(sum(diff.^2,2));      %euclidian norm of each row
     result(:,p)  = diff/norm(diff,1); %normalized prob vector (sum==1)
end

result
[val,ind] = min(result);
testLabels = [ 1 1 1 2 2 2 2 3 3 3 3 3 4 4 5 5 5 5 5 5]; %correct labels, only for prediction accuracy 
acc = sum(ind == testLabels)/ nbTest
%testPredictions