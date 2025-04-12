# [Kernel (image processing)](https://en.wikipedia.org/wiki/Kernel_(image_processing))

- [Kernel (image processing)](#kernel-image-processing)
  - [Details](#details)
    - [Origin](#origin)
    - [Convolution](#convolution)
    - [Edge handling](#edge-handling)
      - [Extend](#extend)
      - [Wrap](#wrap)
      - [Mirror](#mirror)
      - [Crop / Avoid overlap](#crop--avoid-overlap)
      - [Kernel Crop](#kernel-crop)
      - [Constant](#constant)
    - [Normalization](#normalization)
    - [Optimization](#optimization)

In image processing, a kernel, convolution matrix, or mask is a small matrix used for blurring, sharpening, embossing, edge detection, and more. This is accomplished by doing a convolution between the kernel and an image. Or more simply, when each pixel in the output image is a function of the nearby pixels (including itself) in the input image, the kernel is that function.

## Details

The general expression of a convolution is

$$
{\displaystyle g_{x,y}=\omega *f_{x,y}=\sum _{i=-a}^{a}{\sum _{j=-b}^{b}{\omega _{i,j}f_{x-i,y-j}}},}
$$

where ${\displaystyle g(x,y)}$ is the filtered image, ${\displaystyle f(x,y)}$ is the original image, ${\displaystyle \omega }$ is the filter kernel. Every element of the filter kernel is considered by ${\displaystyle -a\leq i\leq a}$ and ${\displaystyle -b\leq j\leq b}$.

### Origin

The origin is the position of the kernel which is above (conceptually) the current output pixel. This could be outside of the actual kernel, though usually it corresponds to one of the kernel elements. For a symmetric kernel, the origin is usually the center element.

### Convolution

Convolution is the process of adding each element of the image to its local neighbors, weighted by the kernel. This is related to a form of mathematical convolution. The matrix operation being performed—convolution—is not traditional matrix multiplication, despite being similarly denoted by $*$.

For example, if we have two three-by-three matrices, the first a kernel, and the second an image piece, convolution is the process of flipping both the rows and columns of the kernel and multiplying locally similar entries and summing. The element at coordinates [2, 2] (that is, the central element) of the resulting image would be a weighted combination of all the entries of the image matrix, with weights given by the kernel:

$$
{\displaystyle \left({\begin{bmatrix}a&b&c\\d&e&f\\g&h&i\end{bmatrix}}*{\begin{bmatrix}1&2&3\\4&5&6\\7&8&9\end{bmatrix}}\right)[2,2]=}
$$
$$
{\displaystyle (i\cdot 1)+(h\cdot 2)+(g\cdot 3)+(f\cdot 4)+(e\cdot 5)+(d\cdot 6)+(c\cdot 7)+(b\cdot 8)+(a\cdot 9).}
$$

The other entries would be similarly weighted, where we position the center of the kernel on each of the boundary points of the image, and compute a weighted sum.

The values of a given pixel in the output image are calculated by multiplying each kernel value by the corresponding input image pixel values.

...

If the kernel is symmetric then place the center (origin) of the kernel on the current pixel. The kernel will overlap the neighboring pixels around the origin. Each kernel element should be multiplied with the pixel value it overlaps with and all of the obtained values should be summed. This resultant sum will be the new value for the current pixel currently overlapped with the center of the kernel.

If the kernel is not symmetric, it has to be flipped both around its horizontal and vertical axis before calculating the convolution as above.

The general form for matrix convolution is

$$
{\displaystyle {\begin{bmatrix}x_{11}&x_{12}&\cdots &x_{1n}\\x_{21}&x_{22}&\cdots &x_{2n}\\\vdots &\vdots &\ddots &\vdots \\x_{m1}&x_{m2}&\cdots &x_{mn}\\\end{bmatrix}}*{\begin{bmatrix}y_{11}&y_{12}&\cdots &y_{1n}\\y_{21}&y_{22}&\cdots &y_{2n}\\\vdots &\vdots &\ddots &\vdots \\y_{m1}&y_{m2}&\cdots &y_{mn}\\\end{bmatrix}}=\sum _{i=0}^{m-1}\sum _{j=0}^{n-1}x_{(m-i)(n-j)}y_{(1+i)(1+j)}}
$$

### Edge handling

Kernel convolution usually requires values from pixels outside of the image boundaries. There are a variety of methods for handling image edges.

#### Extend

The nearest border pixels are conceptually extended as far as necessary to provide values for the convolution. Corner pixels are extended in 90° wedges. Other edge pixels are extended in lines.

#### Wrap

The image is conceptually wrapped (or tiled) and values are taken from the opposite edge or corner.

#### Mirror

The image is conceptually mirrored at the edges. For example, attempting to read a pixel 3 units outside an edge reads one 3 units inside the edge instead.

#### Crop / Avoid overlap

Any pixel in the output image which would require values from beyond the edge is skipped. This method can result in the output image being slightly smaller, with the edges having been cropped. Move kernel so that values from outside of image is never required. Machine learning mainly uses this approach. Example: Kernel size 10x10, image size 32x32, result image is 23x23.

#### Kernel Crop

Any pixel in the kernel that extends past the input image isn't used and the normalizing is adjusted to compensate.

#### Constant

Use constant value for pixels outside of image. Usually black or sometimes gray is used. Generally this depends on application.

### Normalization

Normalization is defined as the division of each element in the kernel by the sum of all kernel elements, so that the sum of the elements of a normalized kernel is unity. This will ensure the average pixel in the modified image is as bright as the average pixel in the original image.

### Optimization

...

