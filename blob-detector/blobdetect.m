function blobs = blobdetect(image, diameter,varargin)
%BLOBDETECT Find locations of dark/bright features.
%

%argparse
p = inputParser;

addRequired(p,'image',@(x) isnumeric(x)&&ismatrix(x));
addRequired(p,'diameter', @(x) isempty(x)||(isnumeric(x)&&0<x));

addParameter(p,'DarkBackground', false, @(x)islogical(x));
addParameter(p,'MedianFilter', true, @(x)islogical(x));
addParameter(p,'KernelSize', 9, @(x)isnumeric(x)&&x>=1);

parse(p, image, diameter, varargin{:})

if p.Results.DarkBackground
    image=imcomplement(image);
end

if p.Results.MedianFilter
    %whatever the default connectivity and radius is
    image=medfilt2(image);
end
%make the LoG kernel
kernel=LoG_kernel(diameter, p.Results.KernelSize);

%FFTconvolve with the kernel
image_conv = conv2(image, kernel, 'same');

%detect local maxima
%TODO handle edges
maxima = imregionalmax(image_conv);

%return list of coordinates
blobs_mask = maxima;
[xs,ys]=find(blobs_mask);
blobs = [xs,ys];
end

function kernel = Laplacian_kernel()
%simple kernel for testing
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
