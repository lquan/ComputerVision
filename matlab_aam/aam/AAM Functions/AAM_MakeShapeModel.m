function [ShapeData TrainingData]= MakeShapeModel(TrainingData)

% Number of datasets
s=length(TrainingData);

% Number of landmarks
nl = length(TrainingData(1).x);

%% Shape model

% Remove rotation and translation and scale : Procrustes analysis 
for i=1:s
    [TrainingData(i).centerx ,TrainingData(i).centery, TrainingData(i).tform]=AAM_align_data(TrainingData(i).x, TrainingData(i).y, TrainingData(1).x, TrainingData(1).y);
end

% Construct a matrix with all contour point data of the training data set
x=zeros(nl*2,s);
for i=1:length(TrainingData)
    x(:,i)=[TrainingData(i).centerx TrainingData(i).centery]';
end
[Evalues, Evectors, x_mean]=PCA(x);

% Keep only 98% of all eigen vectors, (remove contour noise)
i=find(cumsum(Evalues)<sum(Evalues)*0.99,1,'last')+1;
Evectors=Evectors(:,1:i);
Evalues=Evalues(1:i);

% Calculate variances in rotation and scale
r=zeros(nl,1); s=zeros(nl,1);
for i=1:length(TrainingData)
    r(i)=TrainingData(i).tform.offsetr;
    s(i)=TrainingData(i).tform.offsets;
end
varr=var(r); 
vars=var(s);


% Store the Eigen Vectors and Eigen Values
ShapeData.Evectors=Evectors;
ShapeData.Evalues=Evalues;
ShapeData.x_mean=x_mean;
ShapeData.x = x;
ShapeData.SVariance = vars;
ShapeData.RVariance = varr;



