function blobs = blobdetect(image, diameter, dark_background, kernel_size)
%BLOBDETECT Find locations of dark/bright features.
%

%argparse

if dark_background
    image=imcomplement(image);
end

%make the LoG kernel
kernel=LoG_kernel(diameter, kernel_size);

%FFTconvolve with the kernel
%conv2
image_conv = conv2(image, kernel, 'same');

%detect local maxima
%TODO handle edges
maxima = imregionalmax(image_conv);

%return list of coordinates
blobs = maxima;
end

function kernel = Laplacian_kernel()
%simple kernel for test
kernel= [0,-1,0;-1,4,-1;0,-1,0];
end

function kernel = LoG_kernel(diameter, kernel_size)
sigma2 = sqrt(2)*diameter; %sigma^2
%arrays of x, y coordinates distance from center
%handle odd/even kernel_size - always make an odd kernel size,
%rounding up
range=-floor(kernel_size/2):floor(kernel_size/2);
[x,y] = ndgrid(range,range);
%LoG kernel formula
d=(x.^2+y.^2)/(2*sigma2);
kernel= -1/(pi*sigma2)*(1-d)*exp(-d);
%TODO should I discretize to ints?
end
