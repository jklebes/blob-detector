function image_out=annotate_image(image, blob_coords, diameters)
%draws magenta circles on the image
im_double = cast(imadjust(image), 'double')/255;
if size(diameters)==1
    diameters=repmat(diameters, [size(blob_coords),1]);
end
circles = cast(circles_mask(size(image), blob_coords, diameters), 'double');
color = [1,0,1] ; %magenta
image_out = zeros(size(image,1), size(image,2), 3);
image_out(:,:,1)=im_double.*(1-circles)+color(1)*circles;
image_out(:,:,2)=im_double.*(1-circles)+color(2)*circles;
image_out(:,:,3)=im_double.*(1-circles)+color(3)*circles;
end

function mask = circles_mask(dims, centers, diameters)
%an array with 1s in the shape of several hollow circles, with centers
% at 'centers' and diamters 'diameters'
mask=zeros(dims);
for i=1:size(centers)
rad=(diameters(i)/2);
rad_low = (rad)^2;
rad_high=(rad+1)^2; %outline thickness of 1
[x,y] = ndgrid(1:dims(1), 1:dims(2));
cx=centers(i,1);
cy=centers(i,2);
d=(x-cx).^2+(y-cy).^2;
mask = mask | (d < rad_high & d>= rad_low);
end 
end
