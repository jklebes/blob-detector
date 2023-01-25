function blobs = blobdetect(image, diameter, invert, kernel_size)
%LOGBLOBS Summary of this function goes here
%   Detailed explanation goes here

%argparse

if invert
    image=imcomplement(image)
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
%matrices of kernelsize, showing x and y ditance from center
%TODO what should sigma be
sigma2 = sqrt(2)*diameter;

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
