function Ws = AAM_Weights(TrainingData,ShapeData,AppearanceData,options)

Change =zeros(length(TrainingData), size(ShapeData.Evectors,2));
for i=1:length(TrainingData)
    % Remove translation and rotation, as done when training the
    % model.
    [posx,posy,tform]=AAM_align_data(TrainingData(i).x,TrainingData(i).y,TrainingData(1).x,TrainingData(1).y);
        
    % Describe the model by a vector b with model parameters
    x = [posx';posy'];
    b = ShapeData.Evectors'*(x - ShapeData.x_mean);
    
    % Get the intensities of the untransformed shape.
    % Because noisy eigenvectors from the shape were removed, the 
    % contour is on a little different position and
    % intensities probabbly differ a little bit from the orignal appearance
    x_normal= ShapeData.x_mean + ShapeData.Evectors*b;
    posx_normal=x_normal(1:end/2)'; posy_normal=x_normal(end/2+1:end)';
    [posx_normal,posy_normal]=AAM_align_data_inverse(posx_normal,posy_normal,tform);
    g_normal=AAM_Appearance2Vector(TrainingData(i).I,posx_normal,posy_normal, AppearanceData.base_points, AppearanceData.ObjectPixels,options.texturesize);
    g_normal=AAM_NormalizeAppearance(g_normal);
                     
    for j = 1:size(ShapeData.Evectors,2)
            % Change on model parameter a little bit, to see the influence
            % from the shape parameters on appearance parameters
            b_offset=b;  b_offset(j)=b_offset(j)+1;
      
            % Transform the model parameter vector b , back to contour positions
            x_offset= ShapeData.x_mean + ShapeData.Evectors*b_offset;
            posx_offset=x_offset(1:end/2)'; posy_offset=x_offset(end/2+1:end)';
            
            % Now add the previously removed translation and rotation
            [posx_offset,posy_offset]=AAM_align_data_inverse(posx_offset,posy_offset,tform);
            
            g_offset=AAM_Appearance2Vector(TrainingData(i).I,posx_offset,posy_offset, AppearanceData.base_points, AppearanceData.ObjectPixels,options.texturesize);
            g_offset=AAM_NormalizeAppearance(g_offset);
            Change(i,j) = sqrt(sum((g_offset-g_normal).^2)/length(g_normal));
    end
end

Ws=zeros(size(ShapeData.Evectors,2),size(ShapeData.Evectors,2));
for j = 1:size(ShapeData.Evectors,2),
     Ws(j,j) = mean(Change(:,j));
end
