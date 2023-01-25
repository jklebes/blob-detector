function image_out=annotate_image(image, blobs)
%draws dots for now, circles later
im_double = cast(image, 'double')/255;
blobs_double = cast(blobs, 'double');
color = [1,0,1] ; %magenta
image_out = zeros(size(image,1), size(image,2), 3);
image_out(:,:,1)=im_double.*(1-blobs_double)+color(1)*blobs_double;
image_out(:,:,2)=im_double.*(1-blobs_double)+color(2)*blobs_double;
image_out(:,:,3)=im_double.*(1-blobs_double)+color(3)*blobs_double;
end
