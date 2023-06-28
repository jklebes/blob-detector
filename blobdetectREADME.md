# blob-detector
Blob detection by LoG filter. Detects features in 2D, 3D images. [![View blob-detector on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/123905-blob-detector)

Suitable for objects with user-estimated uniform diameter.
now plus 3D version.

See pdf for more background.

## blobdetect
Function to detects positions of bright/dark features in 2D images.

Usage 

```blobcoords=blobdetect(image,diameter)```

#### Arguments

```image``` greyscale image / 2D array.

```diameter``` Diameter of expected objects (in pixels).

#### Optional keyword arguments

```Filter``` select type of filter, from ```"LoG"```, ```"DoG"```, default ```"LoG"```. ``"DoG"`` not yet implemented 3D.

```DarkBackground``` By default bright objects on dark background are expected, if the 
image instead shows dark objects on light background set this to ```false```.  Default ```true```.

```MedianFilter``` The median filter prepocessing step improves quality, default ```true```.

```QualityFilter``` Filter by (linearly rescaled) intensity, default ```0.1```.

```OverlapFilter``` Eliminate circles overlapping by more than radius.  default ```false```.
Warning: slow, O(n^2) in number of particles found. 

```KernelSize``` Size of LoG kernel matrix (gets rounded up to nearest odd number).  Default auto-selected
based on diameter.

```GPU``` Attempt CUDA GPU acceleration.  Default ```false```.  Useful for large 3D images.

#### Output
```blobcoords``` Table of \[x,y, Intensity\] of blob centers.

## blobdetect3D

Function to detect positions of bright/dark features in 3D images.  Input 
arguments same as ``blobdetect``.

```blobcoords=blobdetect3D(image,diameter)```

## annotate_image

Simple utility to inspect output, adds magenta circles to the image.

```image_out=annotate_image(image, coords, diameters)```

This returns an RGB array - the image with magenta circles added - which can then
be inspected using imshow.

For a rough inspection of 3D data and blob coordinate list, call
```image_out=annotate_image(image, coords, diameters, z_height)``` to 
return a 2D image that is a slice through the 3D data at ``z_height``, with 
blobs marked by magenta circles that are slices through the detected spheres
and out-of-plane spheres marked with points.

Alternatively, for immediate display as a figure, you could use matlab's ``viscircles``.

## Handling large and/or 3D images.
Matlab's native convolution ``conv2()`` and ``convn()`` is slow for larger kernels, i.e.
when trying to detect larger blob diameters.

Try installing my [matlabCUDAconvolution](https://uk.mathworks.com/matlabcentral/fileexchange/129964-gpu-cuda-convolution-2d-3d)
 (to somewhere on matlabpath) and 
giving argument ``GPU=true`` to accelerate the convolution step.  Requires a
CUDA-compatible GPU.  

For images that are too large for GPU memory, ``blobdetect``/``blobdetect3D``
 can be applied in a tiled way, see example ``tiledBlobdetect.mlx.

