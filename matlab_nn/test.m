clear;clc

files = dir('./training/*.png');
nbTraining = numel(files);


imNewSize = [32 32];
nbFeatures = prod(imNewSize);

A = zeros(nbTraining,nbFeatures);
%pitch = zeros(nbTraining,2);
pitch = zeros(nbTraining,1);
yaw = zeros(nbTraining,1);
for k=1:nbTraining
    filename = files(k).name;
    I = preprocess(filename,imNewSize);
    A(k,:) = I(:)';
    [p y] = parseFilename3(filename);
    pitch(k) = p;
    yaw(k) = y;
end
%[pc, score, latent] = princomp(double(A),'econ'); %latent
%plot(cumsum(latent)./sum(latent));
%nbPC = 100;

%data = score(:,1:nbPC);
%biplot(pc(:,1:2),'Scores',score(:,1:2))
% unit scaling of data

data = A;
data = (data - repmat(min(data,[],1),size(data,1),1))*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));
% svm training
%model = svmtrain(training_label_vector, training_instance_matrix [, 'libsvm_options']);
% pitch
yaw_model = svmtrain2(yaw, data); %labels(:,1) for pitch
%pitch_model = svmtrain2(labels(:,1), data, '-s 3 -t 2 -g 1 -c 1000 -p 10');

%temp = [score2 labels(:,1)];
%save('pitch10.txt','temp', '-ascii')


files2 = dir('./test/*.png'); %test files
nbTest = numel(files2);
B = zeros(nbTest,nbFeatures);
for k=1:nbTest
    filename = files2(k).name;
    I = preprocess(filename,imNewSize);
    B(k,:) = I(:)';
end

B = (B - repmat(min(B,[],1),size(B,1),1))*spdiags(1./(max(B,[],1)-min(B,[],1))',0,size(B,2),size(B,2));
[pred_label, acc, dec_values] = svmpredict(zeros(nbTest,1), B, pitch_model);

