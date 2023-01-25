# blob-detector
LoG blob detection.

In progress

#blobdetect
For objects with uniform diameter).

####arguments

```image```

```diameter``` Diameter of expected objects.

```kernel```

```dark_background``` By default darks objects on white background are expected, if the 
image shows bright objects on dark background set this to true.

```kernel_size``` Size of LoG kernel matrix (gets rounded up to nearest odd number).

####Output
```blobs``` sparse matrix of blob centers.

#annotate_image

Simple utility to inspect output.



