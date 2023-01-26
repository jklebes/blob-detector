# blob-detector
basic LoG blob detection. [![View blob-detector on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/123905-blob-detector)

# blobdetect
LoG detector for objects with user-estimated uniform diameter.

Usage 

```blobcoords=blobdetect(image,diameter)```

#### Arguments

```image``` greyscale image / 2D array.

```diameter``` Diameter of expected objects (in pixels).

#### Optional keyword arguments

```DarkBackground``` By default dark objects on white background are expected, if the 
image instead shows bright objects on dark background set this to ```true```.  Default ```false```.

```MedianFilter``` The prepocessing step improves quality, default ```true```.

```KernelSize``` Size of LoG kernel matrix (gets rounded up to nearest odd number).  Default ```9```.

#### Output
```[x,y]``` coordinates of blob centers.

# annotate_image

Simple utility to inspect output, adds magenta circles to the image.

```image_out=annotate_image(image, coords, diameters)```



