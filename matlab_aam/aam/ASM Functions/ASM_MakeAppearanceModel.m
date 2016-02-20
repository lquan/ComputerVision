%% Gray-Level Appearance Model
function AppearanceData=ASM_MakeAppearanceModel(TrainingData,options)

% Number of TrainingData sets
s=length(TrainingData);

% Number of landmarks
nl = length(TrainingData(1).x);

% Calculate the normals of the contours of all training data
for i=1:s
  [TrainingData(i).normalsx,TrainingData(i).normalsy]=ASM_GetContourNormals(TrainingData(i).x,TrainingData(i).y);
end

% Inverse of covariance matrix sometimes badly scaled
warning('off','MATLAB:nearlySingularMatrix');

AppearanceData=struct;
% Get the landmark profiles for 3 image scales (for multiscale ASM)
for itt_res=1:options.nscales
    scale=1 / (2^(itt_res-1));

    % Get the pixel profiles of every landmark perpendicular to the contour
    for i=1:s
        px = TrainingData(i).x*scale;  py = TrainingData(i).y*scale;
        Ismall=imresize(TrainingData(i).I,scale);
        nx = TrainingData(i).normalsx; ny = TrainingData(i).normalsy;
        [TrainingData(i).GrayProfiles,TrainingData(i).DerivativeGrayProfiles]=ASM_getProfileAndDerivatives(Ismall,px,py,nx,ny,options.k);
    end

    % Profile length * space for rgb
    pl=(options.k*2+1)*size(TrainingData(1).I,3);
    
    % Calculate a covariance matrix for all landmarks
    PCAData=cell(1,nl);
    for j=1:nl
        %% The orginal search method using Mahanobis distance with
        % edge gradient information
        dg=zeros(pl,s);
        for i=1:s, dg(:,i)=TrainingData(i).DerivativeGrayProfiles(:,j); end
        dg_mean=mean(dg,2);
        dg=dg-repmat(dg_mean,1,s);
        % Calculate the coveriance matrix and its inverse
        AppearanceData(itt_res).Landmarks(j).S = cov(dg');
        AppearanceData(itt_res).Landmarks(j).Sinv = inv(AppearanceData(itt_res).Landmarks(j).S);
        AppearanceData(itt_res).Landmarks(j).dg_mean = dg_mean;
        
        %% The new search method using PCA on intensities, and minimizing
        % parameters / the distance to the mean during the search.
        % Make a matrix with all intensities
        g=zeros(pl,s);
        for i=1:s, g(:,i)=TrainingData(i).GrayProfiles(:,j); end
                
        [Evalues, Evectors, Emean]=PCA(g);
        % Keep only 98% of all eigen vectors, (remove contour noise)
        i=find(cumsum(Evalues)<sum(Evalues)*0.98,1,'last')+1;
        PCAData{j}.Evectors= Evectors(:,1:i);
        PCAData{j}.Evalues = Evalues(1:i);
        PCAData{j}.Emean = Emean;
        
    end
    AppearanceData(itt_res).PCAData=PCAData;
end


