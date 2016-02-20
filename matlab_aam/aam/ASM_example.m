% This Script shows an example of an working basic Active Shape Model,
% with a few hand pictures.
%
% Literature used: Ginneken B. et al. "Active Shape Model Segmentation 
% with Optimal Features", IEEE Transactions on Medical Imaging 2002.
%
% Functions are written by D.Kroon University of Twente (February 2010)

% Add functions path to matlab search path
functionname='ASM_example.m'; functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath([functiondir '/Functions'])
addpath([functiondir '/ASM Functions'])

%% Set options
% Number of contour points interpolated between the major landmarks.
options.ni=20;
% Length of landmark intensity profile
options.k = 8; 
% Search length (in pixels) for optimal contourpoint position, 
% in both normal directions of the contourpoint.
options.ns=6;
% Number of image resolution scales
options.nscales=2;
% Set normal contour, limit to +- m*sqrt( eigenvalue )
options.m=3;
% Number of search itterations
options.nsearch=40;
% If verbose is true all debug images will be shown.
options.verbose=true;
% The original minimal Mahanobis distance using edge gradient (true)
% or new minimal PCA parameters using the intensities. (false)
options.originalsearch=false;  

%% Load training data
% First Load the Hand Training DataSets (Contour and Image)
% The LoadDataSetNiceContour, not only reads the contour points, but 
% also resamples them to get a nice uniform spacing, between the important
% landmark contour points.
TrainingData=struct;
if(options.verbose), figure, end
for i=1:10
    is=num2str(i); number = '000'; number(end-length(is)+1:end)=is; 
    filename=['Fotos/train' number '.mat'];
    [TrainingData(i).x,TrainingData(i).y,TrainingData(i).I]=LoadDataSetNiceContour(filename,options.ni,options.verbose);
    	% Replace the grey level photo by color photo
	TrainingData(i).I=im2double(imread([filename(1:end-4) '.jpg']));

end

%% Shape Model %%
% Make the Shape model, which finds the variations between contours
% in the training data sets. And makes a PCA model describing normal
% contours
[ShapeData TrainingData]= ASM_MakeShapeModel(TrainingData);
  
% Show some eigenvector variations
if(options.verbose)
    figure,
    for i=1:6
        xtest = ShapeData.x_mean + ShapeData.Evectors(:,i)*sqrt(ShapeData.Evalues(i))*3;
        subplot(2,3,i), hold on;
        plot(xtest(end/2+1:end),xtest(1:end/2),'r');
        plot(ShapeData.x_mean(end/2+1:end),ShapeData.x_mean(1:end/2),'b');
    end
end
    
%% Appearance model %%
% Make the Appearance model, which samples a intensity pixel profile/line 
% perpendicular to each contourpoint in each trainingdataset. Which is 
% used to build correlation matrices for each landmark. Which are used
% in the optimization step, to find the best fit.
AppearanceData = ASM_MakeAppearanceModel(TrainingData,options);


%% Test the ASM model %%
Itest=im2double(imread('Fotos/test001.jpg'));

% Initial position offset and rotation, of the initial/mean contour
tform.offsetx=0; tform.offsety=0; tform.offsetr=-0.36;
posx=ShapeData.x_mean(1:end/2)';  posy=ShapeData.x_mean(end/2+1:end)';
[posx,posy]=ASM_align_data_inverse(posx,posy,tform);

% Select the best starting position with the mouse
[x,y]=SelectPosition(Itest,posx,posy);
tform.offsetx=-x; tform.offsety=-y;

% Apply the ASM model onm the test image
ASM_ApplyModel(Itest,tform,ShapeData,AppearanceData,options);


