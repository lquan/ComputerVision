function AAM_ApplyModel(ItestLarge,tformLarge,Data,options)

% We start at the coarse scale
scale=options.nscales; scaling=2^(-(scale-1));

% Transform the coordinates to match the coarse scale
tform=tformLarge;
tform.offsetx=tform.offsetx*scaling;
tform.offsety=tform.offsety*scaling;

% Get the PCA model for this scale
ShapeAppearanceData=Data{scale}.ShapeAppearanceData;
ShapeData=Data{scale}.ShapeData;
AppearanceData=Data{scale}.AppearanceData;

% Use the mean ShapeAppearance parameters to go get an initial contour
b = ShapeAppearanceData.b_mean;
b1 = b(1:(length(ShapeAppearanceData.Ws)));
b1= inv(ShapeAppearanceData.Ws)*b1;
% Initial (mean) aligned coordinates
x = ShapeData.x_mean + ShapeData.Evectors*b1;
% The real image coordinates
[posx,posy]=AAM_align_data_inverse(x(1:end/2),x(end/2+1:end),tform);

   
% Loop through the 4 image size scales
for scale=options.nscales:-1:1
    % Get the PCA model for this scale
    R=Data{scale}.R;
    ShapeAppearanceData=Data{scale}.ShapeAppearanceData;
    ShapeData=Data{scale}.ShapeData;
    AppearanceData=Data{scale}.AppearanceData;
    TrainingData=Data{scale}.TrainingData;
    
    % The image scaling of the scale-itteration
    scaling=2^(-(scale-1));

    % Transform the image and coordinates offset, to the cuurent scale
    Itest=imresize(ItestLarge,scaling);
    if(scale>options.nscales)
        tform.offsetx=tform.offsetx*2;
        tform.offsety=tform.offsety*2;
    end
    
    % From real image coordinates to -> algined coordinates
    [posx_align,posy_align, tform]=AAM_align_data(posx(:)', posy(:)', TrainingData(1).x, TrainingData(1).y);
    x=[posx_align(:);posy_align(:)];
    
    % Start a new figure
    % show current test image, and initial contour
    figure, imshow(Itest); hold on; plot(posy,posx,'r'); h=plot(1,1);
    
    % Sample the image intensities 
    g=AAM_Appearance2Vector(Itest,posx,posy, AppearanceData.base_points, AppearanceData.ObjectPixels,options.texturesize);
    g=AAM_NormalizeAppearance(g);

    % Go from image intesities and contour to ShapeAppearance parameters
    b1 = ShapeAppearanceData.Ws * ShapeData.Evectors' * (x-ShapeData.x_mean);
    b2 = AppearanceData.Evectors' * (g-AppearanceData.g_mean);
    b = [b1;b2];
    c = ShapeAppearanceData.Evectors'*(b -ShapeAppearanceData.b_mean);

    %  Storage of ShapeAppeanance parameters, pose parameters, last
    %  error between model and intensities. Used if old location
    %  had a smaller intensity error.
    c_old=c; tform_old=tform; Eold=inf; 
    
    % Starting step size
    w=1; 
    
    % Search Itterations
    for i=1:options.nsearch
        % Go from ShapeAppearance Parameters to aligned shape coordinates
        b = ShapeAppearanceData.b_mean + ShapeAppearanceData.Evectors*c;
        b1 = b(1:(length(ShapeAppearanceData.Ws)));
        b1= inv(ShapeAppearanceData.Ws)*b1;
        x = ShapeData.x_mean + ShapeData.Evectors*b1;
        
        % From aligned coordinates to real image coordinates
        [posx,posy]=AAM_align_data_inverse(x(1:end/2),x(end/2+1:end),tform);

        % Sample the intensities
        g=AAM_Appearance2Vector(Itest,posx,posy, AppearanceData.base_points, AppearanceData.ObjectPixels,options.texturesize);
        g=AAM_NormalizeAppearance(g);

        % Go from intensities and shape back to ShapeAppearance Parameters
        b1 = ShapeAppearanceData.Ws * ShapeData.Evectors' * (x-ShapeData.x_mean);
        b2 = AppearanceData.Evectors' * (g-AppearanceData.g_mean);
        b = [b1;b2];
        c2 = ShapeAppearanceData.Evectors'*(b -ShapeAppearanceData.b_mean);

        % Go from ShapeAppearance Parameters back to model intensities
        b = ShapeAppearanceData.b_mean + ShapeAppearanceData.Evectors*c2;
        b2 = b(size(ShapeAppearanceData.Ws,1)+1:end);
        g_model = AppearanceData.g_mean + AppearanceData.Evectors*b2;

        % Difference between model and real image intensities
        E=sum((g-g_model).^2);

        % Go back to the old location of the previous itteration, if the
        % error was lower.
        if(E>Eold)
            % Not always go back if the error becomes higher, sometimes
            % stay on the higher error (like in simulated annealing)
            if(rand(1)<0.9)
                % Try a smaller stepsize
                w=w/2;
                c=c_old; tform=tform_old;
            else
                Eold=E; w=1; 
            end
        else
            w=1;  Eold=E;
        end

        % Store model /pose parameters for next itteration
        c_old=c;
        tform_old=tform;
        
        % Calculate the needed model parameter update using the 
        % search model matrix
        c_diff=R*(g-g_model);
        % Update the ShapeApppearance Parameters
        c=c+c_diff(1:end-4).*sqrt(ShapeAppearanceData.Evalues)*w;
        % Update the Pose parameters
        tform.offsetx=tform.offsetx+c_diff(end-3)*w;
        tform.offsety=tform.offsety+c_diff(end-2)*w;  
        tform.offsetsx=tform.offsetsx+c_diff(end-1)*w;
        tform.offsetsy=tform.offsetsy+c_diff(end-0)*w;
        
        % Stay within 3 (m) standard deviations               
        maxc=options.m*sqrt(ShapeAppearanceData.Evalues);
        c=max(min(c,maxc),-maxc);
        
        % Show the current contour
        delete(h); h=plot(posy,posx); 
        % Pause for a moment
        pause(0.1);
    end
    
    % Scale the contour for the next itteration
    if(scale~=1), posx=posx*2; posy=posy*2; end
end
if(E>Eold), c=c_old; tform=tform_old; end   
 
% Go from ShapeAppearance Parameters to Shape and Appearance Parameters
b = ShapeAppearanceData.b_mean + ShapeAppearanceData.Evectors*c;
b1 = b(1:(length(ShapeAppearanceData.Ws)));
b1= inv(ShapeAppearanceData.Ws)*b1;
b2 = b(size(ShapeAppearanceData.Ws,1)+1:end);
g_model = AppearanceData.g_mean + AppearanceData.Evectors*b2;
x = ShapeData.x_mean + ShapeData.Evectors*b1;
        
% From aligned coordinates to real image coordinates
[posx,posy]=AAM_align_data_inverse(x(1:end/2),x(end/2+1:end),tform);
% Sample the intensities
g=AAM_Appearance2Vector(Itest,posx,posy, AppearanceData.base_points, AppearanceData.ObjectPixels,options.texturesize);
c1=std(g(:)); c2=mean(g(:));
g=AAM_NormalizeAppearance(g);


% Show difference between modeled and real intensities of the test image
% object, in the mean shape
figure, 
I_texture=AAM_Vector2Appearance(g_model*c1+c2,AppearanceData.ObjectPixels,options.texturesize);
I_texture2=AAM_Vector2Appearance(g*c1+c2,AppearanceData.ObjectPixels,options.texturesize);

subplot(1,2,1), imshow(I_texture); title('model intensities');
subplot(1,2,2), imshow(I_texture2); title('real intensities');

% Show the modeled image
figure,
I_texture=AAM_Vector2Appearance(g_model*c1+c2,AppearanceData.ObjectPixels,options.texturesize);

% The Piece Wise linear transformation below, only works if contour points are
% unique, and the number of fold-over triangles is small
input_points= AppearanceData.base_points;
base_points=[posx(:) posy(:)];

% Remove control points which give folded over triangles with cp2tform
xy=[input_points(:,2) input_points(:,1)];
uv=[base_points(:,2) base_points(:,1)];
[xy uv]=PreProcessCp2tform(xy,uv);
trans_prj = cp2tform(xy,uv,'piecewise linear');

% Transform the image into the default texture image
ImodelLarge = imtransform(I_texture,trans_prj,'Xdata',[1 size(ItestLarge,2)],'YData',[1 size(ItestLarge,1)],'XYscale',1);
ImodelLarge(isnan(ImodelLarge))=0;
imshow(ImodelLarge); title('The model shown on the found location');

IsegmentedLarge= drawObject(base_points,[size(ItestLarge,1) size(ItestLarge,2)]);
figure, imshow(IsegmentedLarge), title('Area contour');


