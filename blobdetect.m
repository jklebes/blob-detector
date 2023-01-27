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
addParameter(p,'IntensityFilter', true, @(x)islogical(x));

parse(p, image, diameter, varargin{:})

if p.Results.DarkBackground
    image=imcomplement(image);
end

if p.Results.MedianFilter
    %whatever the default connectivity and radius is
    image=medfilt2(image);
end
%make the LoG kernel
sigma_sq = (diameter/(sqrt(2)^3))^2; %sigma = r / sqrt(D) as others use this
    %wrong on wikipedia?
kernel=LoG_kernel(sigma_sq, p.Results.KernelSize);

%FFTconvolve with the kernel
image_conv = conv2(image, kernel, 'same');

%detect local maxima
%TODO handle edges
maxima = imregionalmax(image_conv);

%return list of coordinates
[xs,ys]=find(maxima);

%TODO each maximum is assiged a quality score.  for now just intensity.
quality = zeros([size(xs),1]);
for i=1:size(xs)
    quality(i)=image_conv(xs(i),ys(i));
end

if p.Results.OverlapFilter
    [xs,ys, quality] = overlap_filter(xs,ys,quality,diameter);
end
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

function [xs, ys, quality] = overlap_filter(xs,ys,quality,diameter)
del_list = [];
rad_sq=(diameter/2)^2;
for i=1:size(xs)
    if ~ismember(i, del_list)
    for j=i+1:size(xs)
        if ~ismember(j, del_list) && (xs(i)-xs(j))^2+(ys(i)-ys(j))^2 < rad_sq
            %delete weaker object
            if quality(i)<quality(j)
                del_list(end+1)=i;
            else
                del_list(end+1)=j;
            end
        end
    end
    end
end
xs(del_list)=[];
ys(del_list)=[];
quality(del_list)=[];
end
