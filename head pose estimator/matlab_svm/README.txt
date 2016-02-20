Head pose estimation project
Computer vision 2010-2011

Li Quan/Philippe Tanghe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run the system by executing the script run.m 
(for optimal results, launch the matlabpool before so we can use 
parallel for processing)
this will return the pose results in the struct pose_results
and the face results in the matrix faceResults
it will also write some accuracies in results.txt

!!!this system depends on the LS-SVMlab toolbox!!!

this was tested on Ubuntu 10.10 (64bit) running Matlab 2010B and
a Windows 7 (64bit) running Matlab 2011a, in conjunction with LS-SVMlab1.7.

you can manually train the model by setting the parameter trainingOn or using the script trainHeadPoseEstimator.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folder structure should be as follows (these should all be added to the path):
    neutral_test : contains the 5 neutral test images
    test : contains the 20 test images
    training : contains the 304 training images 
               (use the script flipImages in the folder training to obtain
                the extra mirrored versions)
    (labeled_test) : this optional folder can be used to directly make 
                     test accuracy calculations. it should contain the labeled versions 
                     of the test set.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
list of files:
    faceRecognizer.m
    faceRecognizer.mat
    headPoseEstimator.m
    loadData.m
    parseData.m
    parseFilename.m
    poseEstimator.mat
    run.m
    traingFaceRecognizer.m
    traingHeadPoseEstimator.m
    training/flipImages.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
