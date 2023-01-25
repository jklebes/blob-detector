# blob-detector
basic LoG blob detection.

# blobdetect
LoG detector for objects with user-estimated uniform diameter.

Usage 

```blobmask=blobdetect(image,8)```

#### Arguments

```image``` greyscale image / 2D array.

```diameter``` Diameter of expected objects (in pixels).

#### Optional keyword arguments

```DarkBackground``` By default dark objects on white background are expected, if the 
image instead shows bright objects on dark background set this to ```true```.  Default ```false```.

```MedianFilter``` The prepocessing step improves quality, default ```true```.

```KernelSize``` Size of LoG kernel matrix (gets rounded up to nearest odd number).  Default ```9```.

#### Output
```blobs``` sparse matrix of blob centers.

# annotate_image

Simple utility to inspect output, currently adds magenta points to the image.

```image_out=annotate_image(image, blobmask)```



