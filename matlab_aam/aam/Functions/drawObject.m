function I_texture=drawObject(base_points,texturesize)
% Draw the contour as one closed line white line in an image, and make 
% the object (hand) white using imfill
I_texture=false(texturesize+2);
% Loop through all line coordinates
x=round([base_points(:,1);base_points(1,1)]); x=min(max(x,1),texturesize(1));
y=round([base_points(:,2);base_points(1,2)]); y=min(max(y,1),texturesize(2));
for i=1:(length(x)-1)
   % Calculate the pixels needed to construct a line of 1 pixel thickness
   % between two coordinates.
   xp=[x(i) x(i+1)];  yp=[y(i) y(i+1)]; 
   dx=abs(xp(2)-xp(1)); dy=abs(yp(2)-yp(1));
   if(dx==dy)
     if(xp(2)>xp(1)), xline=xp(1):xp(2); else xline=xp(1):-1:xp(2); end
     if(yp(2)>yp(1)), yline=yp(1):yp(2); else yline=yp(1):-1:yp(2); end
   elseif(dx>dy)
     if(xp(2)>xp(1)), xline=xp(1):xp(2); else xline=xp(1):-1:xp(2); end
     yline=linspace(yp(1),yp(2),length(xline));
   else
     if(yp(2)>yp(1)), yline=yp(1):yp(2); else yline=yp(1):-1:yp(2); end
     xline=linspace(xp(1),xp(2),length(yline));   
   end
   % Insert all pixels in the fill image
   I_texture(round(xline+1)+(round(yline+1)-1)*size(I_texture,1))=1;
end
I_texture=bwfill(I_texture,1,1); I_texture=~I_texture(2:end-1,2:end-1);