# blob-detector
basic LoG blob detection. [![View blob-detector on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/123905-blob-detector)

## blobdetect
LoG (Laplacian of Gaussian) detector suitable for objects with user-estimated uniform diameter.

Usage 

```blobcoords=blobdetect(image,diameter)```

#### Arguments

```image``` greyscale image / 2D array.

```diameter``` Diameter of expected objects (in pixels).

#### Optional keyword arguments

```DarkBackground``` By default bright objects on dark background are expected, if the 
image instead shows dark objects on light background set this to ```false```.  Default ```true```.

```MedianFilter``` The median filter prepocessing step improves quality, default ```true```.

```OverlapFilter``` Eliminate circles overlapping by more than radius.  default ```true```.

```KernelSize``` Size of LoG kernel matrix (gets rounded up to nearest odd number).  Default ```9```.

#### Output
```blobcoords``` \[xs, ys\] coordinates of blob centers.

## annotate_image

Simple utility to inspect output, adds magenta circles to the image.

```image_out=annotate_image(image, coords, diameters)```

This returns an RGB array.  Alternatively, for immediate display as a figure, you could use matlab's ``viscircles``.



# Not yet implemented
* handle image edges
* automatically adjust kernel size
