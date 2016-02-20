Head pose estimation project
Computer vision 2010-2011

Li Quan/Philippe Tanghe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run the system by executing the script testNeural.m 
(for optimal results, launch the matlabpool before so we can use 
parallel for processing)
this will return the pose results in the struct pose_results

! This system depends on the neural network toolbox of matlab, which should be already installed.

this was tested on Ubuntu 10.10 (64bit) running Matlab 2010B and
a Windows 7 (64bit) running Matlab 2011a

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder structure should be as follows (these should all be added to the path):
    test : contains the 20 test images (if they're labeled just as the training images, you can calculate the test accuracies)
    training : contains the 304 training images 
               (use the script flipImages in the folder training to obtain
                the extra mirrored versions)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
list of files:
    convertResults.m
    net1.mat
	net2.mat
    nprPitch.m
	nprYaw.m
	parseFilename.m
	preprocess.m
	testNeural.m
    training/flipImages.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
You can change the following parameters:
	In testNeural:
		doPCA: set to true if you want to use PCA on the data (instead of using the "raw images" as input)
		outputResults: set to true for outputting results that can be outputted:
			the training accuracies if doTrain is true
			the test accuracies if useTestLabeling is true
			the predictions on the test set
		useTestLabeling: if the test data is labeled you can set this to true to use it for test accuracy calculations
		doTrain: set to true if you want to train a new set of neural networks (necessary if value of doPCA is changed)
	In nprPitch & nprYaw (most important):
		hiddenLayerSize: (line 14) the size of the hidden layer
		netX.divideParam.trainRatio: the ratio of examples in the trainingset (for crossvalidation)
		netX.divideParam.valRatio: set to 1 - netX.divideParam.trainRatio
