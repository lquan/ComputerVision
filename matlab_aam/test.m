%% initialiasation
clc
file = 'C:/Users/li/Desktop/computer vision test/bs004_N_N_0';



%% Load the first training image
I = imread([file '.png']);



%% and its landmarks
lmstruct = BO_readlm([file '.lm2']);
lmstruct.Type;
lmstruct.Location;

%% iterate over landmark points and indicate them
coordinates = lmstruct.Location;%round(lmstruct.Location);

%% show the image
imtool(I)

figure
imshow(I,'Border','Tight')
hold on
plot(coordinates(1,:),coordinates(2,:),'r*')
hold off



