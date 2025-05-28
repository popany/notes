[Matrix calculus](https://en.wikipedia.org/wiki/Matrix_calculus)

- [Scope](#scope)
- [Notation](#notation)
- [Derivatives with vectors](#derivatives-with-vectors)
  - [Vector-by-scalar](#vector-by-scalar)
  - [Scalar-by-vector](#scalar-by-vector)
  - [Vector-by-vector](#vector-by-vector)
- [Derivatives with matrices](#derivatives-with-matrices)
  - [Matrix-by-scalar](#matrix-by-scalar)
  - [Scalar-by-matrix](#scalar-by-matrix)
  - [Other matrix derivatives](#other-matrix-derivatives)
- [Layout conventions](#layout-conventions)
- [Identities](#identities)

...

Two competing notational conventions split the field of matrix calculus into two separate groups. The two groups can be distinguished by whether they write the derivative of a scalar with respect to a vector as a column vector or a row vector. Both of these conventions are possible even when the common assumption is made that vectors should be treated as column vectors when combined with matrices (rather than row vectors). 

...

## Scope

...

Matrix notation serves as a convenient way to collect the many derivatives in an organized way.

...

There are a total of nine possibilities using scalars, vectors, and matrices. Notice that as we consider higher numbers of components in each of the independent and dependent variables we can be left with a very large number of possibilities. The six kinds of derivatives that can be most neatly organized in matrix form are collected in the following table.

**Types of matrix derivative**

|Types|Scalar|Vector|Matrix|
|----|------|------|-------|
|Scalar|${\displaystyle {\frac {\partial y}{\partial x}}}$|${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$|${\displaystyle {\frac {\partial \mathbf {Y} }{\partial x}}}$
|Vector|${\displaystyle {\frac {\partial y}{\partial \mathbf {x} }}}$|${\displaystyle {\frac {\partial \mathbf {y} }{\partial \mathbf {x} }}}$||
|Matrix|${\displaystyle {\frac {\partial y}{\partial \mathbf {X} }}}$

Here, we have used the term "matrix" in its most general sense, recognizing that vectors are simply matrices with one column (and scalars are simply vectors with one row). Moreover, we have used bold letters to indicate vectors and bold capital letters for matrices. This notation is used throughout.

...

## Notation

...

## Derivatives with vectors

...

### Vector-by-scalar

The derivative of a vector ${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$, by a scalar $x$ is written (in numerator layout notation) as

$$
{\displaystyle {\frac {d\mathbf {y} }{dx}}={\begin{bmatrix}{\frac {dy_{1}}{dx}}\\{\frac {dy_{2}}{dx}}\\\vdots \\{\frac {dy_{m}}{dx}}\\\end{bmatrix}}.}
$$

In vector calculus the derivative of a vector $\mathbf {y}$ with respect to a scalar $x$ is known as the tangent vector of the vector $\mathbf {y}$, ${\displaystyle {\frac {\partial \mathbf {y} }{\partial x}}}$. Notice here that $\mathbf {y}: \mathbf {R}^{1} \rightarrow \mathbf {R}^{m}$.

### Scalar-by-vector

The derivative of a scalar $y$ by a vector ${\displaystyle \mathbf {x} ={\begin{bmatrix}x_{1}&x_{2}&\cdots &x_{n}\end{bmatrix}}^{\mathsf {T}}}$, is written (in numerator layout notation) as

$$
{\displaystyle {\frac {\partial y}{\partial \mathbf {x} }}={\begin{bmatrix}{\dfrac {\partial y}{\partial x_{1}}}&{\dfrac {\partial y}{\partial x_{2}}}&\cdots &{\dfrac {\partial y}{\partial x_{n}}}\end{bmatrix}}.}
$$

In vector calculus, the gradient of a scalar field $\mathbf{f} : \mathbf{R}^n \rightarrow \mathbf{R}$ (whose independent coordinates are the components of $x$) is the transpose of the derivative of a scalar by a vector.

$$
{\displaystyle \nabla f={\begin{bmatrix}{\frac {\partial f}{\partial x_{1}}}\\\vdots \\{\frac {\partial f}{\partial x_{n}}}\end{bmatrix}}=\left({\frac {\partial f}{\partial \mathbf {x} }}\right)^{\mathsf {T}}}
$$

> 💡 理解：  
> 上面公式中的 $\nabla f$ 应当被理解为一个列矢量

By example, in physics, the electric field is the negative vector gradient of the electric potential.

The directional derivative of a scalar function $f(\mathbf{x})$ of the space vector $\mathbf{x}$ in the direction of the unit vector $\mathbf{u}$ (represented in this case as a column vector) is defined using the gradient as follows.

$$
{\displaystyle \nabla _{\mathbf {u} }{f}(\mathbf {x} )=\nabla f(\mathbf {x} )\cdot \mathbf {u} }
$$

> 💡 理解：  
> 上面公式中的 $\nabla f(\mathbf{x})$ 是一个列矢量，点乘另一个列矢量 $\mathbf{u}$，结果为一个标量。两个列矢量的点乘并没有用矩阵乘法的形式（即前一个列矢量没有加转置符号）。也可能是上面公式中仅表示两个矢量点乘，不涉及是行矢量或者列矢量，所以没有加转置符号。

Using the notation just defined for the derivative of a scalar with respect to a vector we can re-write the directional derivative as ${\displaystyle \nabla _{\mathbf {u} }f={\frac {\partial f}{\partial \mathbf {x} }}\mathbf {u} .}$ This type of notation will be nice when proving product rules and chain rules that come out looking similar to what we are familiar with for the scalar derivative.

> 💡 理解：  
> 上文中的 ${\displaystyle \nabla _{\mathbf {u} }f={\frac {\partial f}{\partial \mathbf {x} }}\mathbf {u} .}$ 是符合矩阵乘法的，${\displaystyle \frac {\partial f}{\partial \mathbf {x} }}$ 是一个行矢量，$\mathbf{u}$ 是一个列矢量。

### Vector-by-vector

Each of the previous two cases can be considered as an application of the derivative of a vector with respect to a vector, using a vector of size one appropriately. Similarly we will find that the derivatives involving matrices will reduce to derivatives involving vectors in a corresponding way.

The derivative of a vector function (a vector whose components are functions) ${\displaystyle \mathbf {y} ={\begin{bmatrix}y_{1}&y_{2}&\cdots &y_{m}\end{bmatrix}}^{\mathsf {T}}}$, with respect to an input vector, ${\displaystyle \mathbf {x} ={\begin{bmatrix}x_{1}&x_{2}&\cdots &x_{n}\end{bmatrix}}^{\mathsf {T}}}$, is written (in numerator layout notation) as

$$
{\displaystyle {\frac {\partial \mathbf {y} }{\partial \mathbf {x} }}={\begin{bmatrix}{\frac {\partial y_{1}}{\partial x_{1}}}&{\frac {\partial y_{1}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{1}}{\partial x_{n}}}\\{\frac {\partial y_{2}}{\partial x_{1}}}&{\frac {\partial y_{2}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{2}}{\partial x_{n}}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y_{m}}{\partial x_{1}}}&{\frac {\partial y_{m}}{\partial x_{2}}}&\cdots &{\frac {\partial y_{m}}{\partial x_{n}}}\\\end{bmatrix}}.}
$$

In vector calculus, the derivative of a vector function $\mathbf{y}$ with respect to a vector $\mathbf{x}$ whose components represent a space is known as the pushforward (or differential), or the Jacobian matrix.

The pushforward along a vector function $\mathbf{f}$ with respect to vector $\mathbf{v}$ in $\mathbf{R}^{n}$ is given by ${\displaystyle d\mathbf {f} (\mathbf {v} )={\frac {\partial \mathbf {f} }{\partial \mathbf {v} }}d\mathbf {v} .}$

## Derivatives with matrices

...

### Matrix-by-scalar

The derivative of a matrix function $\mathbf{Y}$ by a scalar $x$ is known as the tangent matrix and is given (in numerator layout notation) by

$$
{\displaystyle {\frac {\partial \mathbf {Y} }{\partial x}}={\begin{bmatrix}{\frac {\partial y_{11}}{\partial x}}&{\frac {\partial y_{12}}{\partial x}}&\cdots &{\frac {\partial y_{1n}}{\partial x}}\\{\frac {\partial y_{21}}{\partial x}}&{\frac {\partial y_{22}}{\partial x}}&\cdots &{\frac {\partial y_{2n}}{\partial x}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y_{m1}}{\partial x}}&{\frac {\partial y_{m2}}{\partial x}}&\cdots &{\frac {\partial y_{mn}}{\partial x}}\\\end{bmatrix}}.}
$$

### Scalar-by-matrix

The derivative of a scalar function $y$, with respect to a $p \times q$ matrix $\mathbf{X}$ of independent variables, is given (in numerator layout notation) by

$$
{\displaystyle {\frac {\partial y}{\partial \mathbf {X} }}={\begin{bmatrix}{\frac {\partial y}{\partial x_{11}}}&{\frac {\partial y}{\partial x_{21}}}&\cdots &{\frac {\partial y}{\partial x_{p1}}}\\{\frac {\partial y}{\partial x_{12}}}&{\frac {\partial y}{\partial x_{22}}}&\cdots &{\frac {\partial y}{\partial x_{p2}}}\\\vdots &\vdots &\ddots &\vdots \\{\frac {\partial y}{\partial x_{1q}}}&{\frac {\partial y}{\partial x_{2q}}}&\cdots &{\frac {\partial y}{\partial x_{pq}}}\\\end{bmatrix}}.}
$$

Important examples of scalar functions of matrices include the trace of a matrix and the determinant.

In analog with vector calculus this derivative is often written as the following.

$$
{\displaystyle \nabla _{\mathbf {X} }y(\mathbf {X} )={\frac {\partial y(\mathbf {X} )}{\partial \mathbf {X} }}}
$$

Also in analog with vector calculus, the directional derivative of a scalar $f(\mathbf{X})$ of a matrix $\mathbf{X}$ in the direction of matrix $\mathbf{Y}$ is given by

$$
{\displaystyle \nabla _{\mathbf {Y} }f=\operatorname {tr} \left({\frac {\partial f}{\partial \mathbf {X} }}^{T}\mathbf {Y} \right).}
$$

> 💡 理解：  
> 实际上方向导数 $\nabla_{\mathbf {Y}}f$ 应该通过弗罗贝尼乌斯内积（对应元素乘积之和）计算，即：${\displaystyle \nabla_{\mathbf {Y}}f = \sum_{i=1}^{p} \sum_{j=1}^{q} \frac{\partial f}{\partial x_{ij}} y_{ij} }$。  
> 文中表达式中的 ${\displaystyle {\frac {\partial f}{\partial \mathbf {X} }}^{T}}$ 是一个 $p \times q$ 的矩阵，与矩阵 $\mathbf{Y}$ 的形状相同，这是不符合矩阵乘法的。正确的形式应该是不带转置符号的，这里不知道为什么带了转置符号，可能正文中的矩阵乘法表达式用了某种其他的约定。

### Other matrix derivatives

The three types of derivatives that have not been considered are those involving vectors-by-matrices, matrices-by-vectors, and matrices-by-matrices. These are not as widely considered and a notation is not widely agreed upon.

## Layout conventions

...

## Identities

...

