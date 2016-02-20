function [ result ] = faceRecognizer( testFiles )
%FACERECOGNIZER makes a prediction of the given files
% It will automatically train the system using the hard-coded directories,
% if the file 'faceRecognizer.mat' was not found
%   IN
%       testFiles - the files to make a prediction for (use dir function)
%
%   OUT 
%       result    - matrix containing the disimilarity of each test image
%                   with the five images in the db (columnwise) 5x20

%% check if training needed
if (~exist('faceRecognizer.mat','file'))
    trainingFiles = dir('./training/bs*N_N*.png');
    databaseFiles = dir('./neutral_test/*.png');
    faceRecognizer = trainFaceRecognizer( trainingFiles, databaseFiles);
    save('faceRecognizer.mat', 'faceRecognizer');
end

%% load face recognition system and load test images
load('faceRecognizer.mat');
testImages = loadData(testFiles,faceRecognizer.imSize);
testImages = bsxfun(@minus, testImages, faceRecognizer.meanFace);
testImages = testImages * faceRecognizer.pc;

%testPredictions = simlssvm(model, testImages);
%testImages = scaleData(testImages, scaleInfo);
%[predictions] = svmpredict(testLabels, testImages, face_recognizer);

%% calculate dissimilarity scores using Euclidian distance 
% (mahalonibis should be better, not yet implemented)
database = faceRecognizer.database;
nbDatabase = size(database,1);
nbTest = numel(testFiles);
result = zeros(nbDatabase,nbTest);  % 5 x 20
for p = 1:nbTest
     %we loop through each test images and compare to each in the database
     testImage = repmat(testImages(p,:), [nbDatabase,1]);
     diff = testImage - database;      %difference
     diff = sqrt(sum(diff.^2,2));      %euclidian norm of each row
     result(:,p)  = diff/norm(diff,1); %normalized prob vector (sum==1)
end

end

