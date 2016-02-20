% this script creates additional test data by flipping images
% more specifically, we have images at R10, 20 and 30 degrees 
% and flip them to get L10, 20 and 30 degrees
% ATTENTION! this script will save the images in the working
%            directory. therefore, it is preferable to run
%            this script in the training images directory

fileNames = {'bs*_YR_R10*.png'; 
             'bs*_YR_R20*.png'; 
             'bs*_YR_R30*.png'}; 
for k=1:numel(fileNames)
    files = dir(fileNames{k});
    parfor t=1:numel(files)
        f = files(t).name;
        im = flipdim(imread(f),2); %flip horizontally
        f(end-8) = 'L';            %we change the R in L
        imwrite(im, f);
    end
end
