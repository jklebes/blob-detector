# blob-detector
LoG blob detection.

In progress

# blobdetect
LoG detector for objects with user-estimated uniform diameter.

Usage 

```blobmask=blobdetect(image,8)```

#### Arguments

```image``` greyscale image / 2D array.

```diameter``` Diameter of expected objects (in pixels).

#### Optional keyword arguments

```darkBackground``` By default dark objects on white background are expected, if the 
image shows bright objects on dark background set this to true.  Default ```false```.

```medianFilter``` The prepocessing step improves quality, default ```true```.

```kernelSize``` Size of LoG kernel matrix (gets rounded up to nearest odd number).  Default ```9```.

#### Output
```blobs``` sparse matrix of blob centers.

# annotate_image

Simple utility to inspect output, currently adds magenta points to the image.



