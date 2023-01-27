function blobs = blobdetect(image, diameter,varargin)
%BLOBDETECT Find locations of dark/bright features.
%

%argparse
p = inputParser;

addRequired(p,'image',@(x) isnumeric(x)&&ismatrix(x));
addRequired(p,'diameter', @(x) isempty(x)||(isnumeric(x)&&0<x));

addParameter(p,'DarkBackground', true, @(x)islogical(x));
addParameter(p,'MedianFilter', true, @(x)islogical(x));
addParameter(p,'KernelSize', 9, @(x)isnumeric(x)&&x>=1);
addParameter(p,'OverlapFilter', true, @(x)islogical(x));

parse(p, image, diameter, varargin{:})

if p.Results.DarkBackground
    image=imcomplement(image);
end

if p.Results.MedianFilter
    %whatever the default connectivity and radius is
    image=medfilt2(image);
end
%make the LoG kernel
sigma_sq = diameter/(sqrt(2)^3); %sigma^2
kernel=LoG_kernel(sigma_sq, p.Results.KernelSize);

%FFTconvolve with the kernel
image_conv = conv2(image, kernel, 'same');

%detect local maxima
%TODO handle edges
maxima = imregionalmax(image_conv);

%TODO overlapfilter

%return list of coordinates
[xs,ys]=find(maxima);
blobs = [xs,ys];
end

function kernel = Laplacian_kernel()
%simple kernel for testing
kernel= [0,-1,0;-1,4,-1;0,-1,0];
end

function kernel = LoG_kernel(sigma_sq, kernel_size)
%arrays of x, y coordinates distance from center
%handle odd/even kernel_size - always make an odd kernel size,
%rounding up
range=-floor(kernel_size/2):floor(kernel_size/2);
[x,y] = ndgrid(range,range);
%LoG kernel formula
d=(x.^2+y.^2)/(2*sigma_sq);
kernel= -1/(pi*sigma_sq^2)*(1-d).*exp(-d);
%TODO should I discretize to ints?
end

function kernel = Gaussian_kernel(sigma_sq, kernel_size)
%DoG faster?  Good for small objects.
end
