function [ faceRecognizer ] = trainFaceRecognizer( trainingFiles, databaseFiles)
%TRAINFACERECOGNIZER trains the face recognizer given the trainingfiles and
% databasefiles
%
% IN
%   trainingFiles  - files (dir function)
%   databaseFiles  - neutral database files (dir function)
%
% OUT
%   faceRecognizer - struct containing face recognition system


imSize = [64, 64];
trainingData = loadData(trainingFiles, imSize);

%% eigenface (PCA analysis)
meanFace = mean(trainingData,1);
[pc,~,~] = princomp(trainingData,'econ'); %normalization is performed internally

nbPC = 20;               % can be chosen via (e.g. 98%) %cumsum(latent)/sum(latent)
%score = score(:,1:nbPC); % our original observations in projection space
pc = pc(:,1:nbPC);       % principal components (i.e. eigenfaces)

%%plot first four eigenfaces
%figure;
%for k=1:4
%    subplot(2,2,k);
%    eigenface = reshape(pc(:,k),imSize);     % Reshape into 2D array
%    imagesc(eigenface);                      % Display as image scaled 0-255
%    colormap(gray(256))
%end

%% our database of known images projected in eigenface subspace
database = loadData(databaseFiles, imSize);
database = bsxfun(@minus, database, meanFace);
database = database * pc;

%labels = (1:numel(databaseFiles))'; %labels in alphabetic order
%face_recognizer = svmtrain2(labels, database);
%model = initlssvm(database,labels,'classifier',[],[],'RBF_kernel');
%model = tunelssvm(model,'simplex','leaveoneoutlssvm',{'misclass'},'code_OneVsAll');
%model = trainlssvm(model);

%[facePredictions,~,~,~,~,faceRecognizer] = lssvm(database, labels, 'c');

faceRecognizer = struct;
faceRecognizer.imSize = imSize;
faceRecognizer.database = database;
faceRecognizer.meanFace = meanFace;
faceRecognizer.pc = pc;
end

