%% parameters
% when changing doPCL you need to train an appropriate network
clear;clc;
doPCL = false; % use PCL on the data
outputResults = true; % output the accuracies and the estimations on the (labeled) test set
useTestLabeling = false; % if test files are appropriately labeled, you can use it to calculate the accuracy
doTrain = false; % do training (if no training, also no training accuracy output)

%% initialisation vars
if (doTrain)
    files = dir('./training/*.png'); % training data
    nbTraining = numel(files);
end
imNewSize = [32 32];  %resize dimensions
nbFeatures = prod(imNewSize);  

files2 = dir('./test/*.png'); %test files
nbTest = numel(files2);

if (doTrain)
    %% process the training data
    A = zeros(nbFeatures,nbTraining);
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
    if(doPCL)
        A=A';
        colMeans = mean(A);
        % perform pca
        nbPC = 20;
        [pc, score] = princomp(A,'econ');
        A = (score(:,1:nbPC));
    end;
end;

%% process the test data
B = zeros(nbFeatures,nbTest);
tpitch = zeros(5,nbTest);
tyaw = zeros(11,nbTest);
parfor k=1:nbTest
    filename = files2(k).name;
    I = preprocess(filename, imNewSize); 
    B(:,k) = double(I(:));
    
    if (useTestLabeling)
        [p, y] = parseFilename(filename);
        tpitch(:,k) = p;
        tyaw(:,k) = y;
    end
end
if (doPCL)
    B=B';
    B = (bsxfun(@minus, B, colMeans));
    pcb = pc(:,1:nbPC);
    B = (B * pcb);
end
clear I J p y filename k  %cleanup of unnecessary vars

if (doTrain)
    %% neural network training
    if (doPCL), A = A'; end;
    nprYaw;
    nprPitch;
	save('net1','net1');
	save('net2','net2');
else
    load('net1');
    load('net2');
end

if (doTrain)
    %% use the NN on the training set
    tryp = net1(A);
    trpp = net2(A);
    [training_est, training_res] = convertResults(tryp, trpp);
    
    % calculate accuracy
    [~, train_or] = convertResults(yaw, pitch);
    nbright = 0;
    parfor k=1:nbTraining
        if (train_or(k,:) == training_res(k,:))
            nbright = nbright + 1;
        end
    end
    train_acc = nbright/nbTraining;
    train_p_acc = sum(train_or(:,2) == training_res(:,2))/nbTraining;
    train_y_acc = sum(train_or(:,1) == training_res(:,1))/nbTraining;
end
%% now use the NN to predict on the test set
if (doPCL), B=B'; end;
yaw_predictions = net1(B);
pitch_predictions = net2(B);
[pose_estimations, results] = convertResults(yaw_predictions,pitch_predictions);

if (useTestLabeling)
    % calculate accuracy
    [~, test_or] = convertResults(tyaw, tpitch);
    % tpitch
    % tyaw
    % test_or
    nbright = 0;
    parfor k=1:nbTest
        if (test_or(k,:) == results(k,:))
            nbright = nbright + 1;
        end
    end
    test_acc = nbright/nbTest;
    test_p_acc = sum(test_or(:,2) == results(:,2))/nbTest;
    test_y_acc = sum(test_or(:,1) == results(:,1))/nbTest;
end

if (outputResults)
    if (doTrain)
        fprintf('\n\nyaw training set accuracy: %f\n', train_y_acc);
        fprintf('pitch training set accuracy: %f\n', train_p_acc);
        fprintf('combined training set accuracy: %f\n', train_acc);
    end
    if (useTestLabeling)
        fprintf('\nyaw test set accuracy: %f\n', test_y_acc);
        fprintf('pitch test set accuracy: %f\n', test_p_acc);
        fprintf('combined training set accuracy: %f\n', test_acc);
    end
    display(results);
end


%% check again on the training set
%yaw_predictions2 = net1(A);
%pitch_predictions2 = net2(A);
%[~, results2] = convertResults(yaw_predictions2,pitch_predictions2);

%display(results2);

