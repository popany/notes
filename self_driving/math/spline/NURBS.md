# NURBS

- [NURBS](#nurbs)
  - [NURBS 是什么?](#nurbs-是什么)
    - [什么是 NURBS 几何图形?](#什么是-nurbs-几何图形)
      - [阶数](#阶数)
      - [控制点](#控制点)
      - [节点 (Knot)](#节点-knot)
      - [节点（Knot）与控制点](#节点knot与控制点)
      - [估计法则](#估计法则)
  - [What is a NURBS?](#what-is-a-nurbs)
    - [Bézier curves](#bézier-curves)
    - [Curve degree](#curve-degree)
    - [Rational curves](#rational-curves)
    - [B-Splines](#b-splines)
    - [NURBS](#nurbs-1)
  - [Bézier curve](#bézier-curve)

## [NURBS 是什么?](https://www.rhino3d.com/features/nurbs/)

NURBS，非均匀有理 B 样条曲线，无论是简单的 2D 直线、圆形、圆弧或曲线，还是更多复杂的 3D 有机自由曲面或实体，它都可以准确地描述。由于其灵活性和准确性，NURBS 模型可用于从二维图纸到动画制作再到生产制造的任意过程。

NURBS 几何图形有五个重要的特质，这些特质让它成为电脑辅助建模的理想选择。

- NURBS 几何形状的转换可遵循一定的行业标准 。客户可根据其实际需求在各种建模、渲染、动画和工程分析程序之间进行模型的转换。
- NURBS 的精确性众所周知。而且大多数的一流大学都会教授 NURBS 几何数学和计算机科学的内容。这意味着大学为那些需要创建定制软件的专业软件供应商、工程团队、工业设计公司和动画公司培养了能够使用 NURBS 几何图形的程序员。
- NURBS可以准确地表达标准的几何物件，如直线、圆、椭圆、球体、圆环，以及自由形状的几何体，如车体和人体。
- 以 NURBS 呈现的几何图形所需的数据量远比一般的网格形式要少。
- 下面讨论的 NURBS 评估规则可以在计算机上高效而准确地实现。

### 什么是 NURBS 几何图形?

NURBS 曲线和曲面的描述类似，并且使用相同的术语。由于曲线比较容易描述，因此我们将对其进行详细介绍。定义 NURBS 曲线的四个要素：阶数、控制点、节点和评估规则。

#### 阶数

**阶数 (Degree)** 是正整数。

通常使用到的是1、 2、3 或 5 阶，当然也可以是任何正整数。NURBS 直线和多重直线通常是1阶，NURBS 圆是 2 阶，大多数自由形式的曲线是 3 阶或 5 阶。有时会使用线性、二次方、三次方和五次方等术语。线性意思是 1 阶，二次方意思是 2 阶，三次方意思是 3 阶，五次方意思是 5 阶。

您也可能会看到某些地方提及 NURBS 曲线的**次数 (Order)**，一条 NURBS 曲线的次数等于阶数+1的正整数，所以阶数也等于次数-1。

有可能提高一个曲线的阶数但其形状却没有发生改变。 通常，减少一个曲线的阶数一定会影响其形状。

#### 控制点

控制点是一个点的列表，控制点的**最小数目是阶数+1**。

改变 NURBS 曲线形状最简单的方法之一是移动它的控制点。

控制点有一个称为权重值的关联数值。除少数情况外，权重都是正数。当一条曲线的控制点都具有相同的权重值(通常为1)时，这条曲线就称为**非有理曲线**。否则，这条曲线就叫做有理曲线。NURBS 中的 R 代表有理，表示一条 NURBS 曲线具有有理的可能性。实际上，大多数 NURBS 曲线是非有理曲线。当然还是有一些 NURBS 曲线、圆和椭圆是例外，是有理的曲线。

#### 节点 (Knot)

**节点 (Knot)** 是一个 **(阶数 + N - 1)** 的数字列表，N 代表控制点数目。有时候这个列表上的数字也称为**节点矢量 (Knot Vector)**，这里的矢量并不是指 3D 方向。

节点列表上的数字必须符合几个条件，确定条件是否符合的标准方式是在列表上往下时，数字必需维持不变或变大，而且**数字重复的次数不可以比阶数大**。例如，阶数 3 有 15 个控制点的 NURBS 曲线，列表数字为 0,0,0,1,2,2,2,3,7,7,9,9,9 是一个符合条件的节点列表。列表数字为 0,0,0,1,2,2,2,2,7,7,9,9,9 则不符合，因为此列表中有四个 2，而四比阶数大 (阶数为 3)。

节点值重复的次数称为**节点的重数 (Multiplicity)**，在上面例子中符合条件的节点列表中，节点值 0 的重数值为三；节点值 1 的重数值为一；节点值 2 的重数为三；节点值 7 的重数值为二；节点值 9 的重数值为三。如果节点值重复的次数和阶数一样，该节点值称为全复节点 (Full-Multiplicity Knot)。在上面的例子中，节点值 0、2、9 有完整的重数，只出现一次的节点值称为单纯节点 (Simple Knot)，节点值 1 和 3 为单纯节点。

如果在节点列表中是以全复节点开始，接下来是单纯节点，再以全复节点结束，而且节点值为等差，称为均匀 ( Uniform )。例如，如果阶数为 3 有 7 个控制点的 NURBS 曲线，其节点值为 0,0,0,1,2,3,4,4,4，那么该曲线有均匀的节点。如果节点值是 0,0,0,1,2,5,6,6,6 不是均匀的，称为**非均匀 (Non-Uniform)**。在 NURBS 的 NU 代表“非均匀”，意味着在一条 NURBS 曲线中节点可以是非均匀的。

在节点值列表中段有重复节点值的 NURBS 曲线比较不平滑，最不平滑的情形是节点列表中段出现全复节点，代表曲线有锐角。因此，有些设计师喜欢在曲线插入或移除节点，然后调整控制点，使曲线的造型变得平滑或尖锐，Rhino 也有移除或插入节点的工具。因为节点数等于 (N + 阶数 - 1)，N 代表控制点的数量，所以插入一个节点会增加一个控制点，移除一个节点也会减少一个控制点。插入节点时可以不改变 NURBS 曲线的形状，但通常移除节点必定会改变 NURBS 曲线的形状。Rhino 也允许您直接删除控制点，删除控制点时也会删除一个节点。

#### 节点（Knot）与控制点

控制点和节点是一对一成对的是常见的错误概念，这种情形只发生在 1 阶的 NURBS (多重直线)。较高阶数的 NURBS 的**每 (2 x 阶数) 个节点是一个群组**，**每 (阶数 + 1) 个控制点是一个群组**。例如，一条 3 阶 7 个控制点的 NURBS 曲线，节点是 0,0,0,1,2,5,8,8,8，前四个控制点是对应至前六个节点；第二至第五个控制点是对应至第二至第七个节点 0,0,1,2,5,8；第三至第六个控制点是对应至第三至第八个节点 0,1,2,5,8,8；最后四个控制点是对应至最后六个节点。

某些建模软件使用较旧的 NURBS 估计演算法，该演算法需要额外的两个节点值，总数为 (阶数 + N + 1) 个节点。当 Rhino 导出或导入这种类型的 NURBS 几何图形时会自动加入或移除两个节点。

#### 估计法则

曲线评估规则是采取数字并且分配一个点的一个数学公式。

该方程序涉及阶数、控制点、节点，并含有某些 B-样条曲线基础函数 (B-spline basis functions)。NURBS 的 B 和 S 代表 B-样条曲线 (B-Spline)。NURBS 的估计法则是由参数开始，您可以将估计法则视为一个黑盒子，每当这个黑盒子吃进一个参数就会产生一个点，而黑盒子如何运作是阶数、节点、控制点所控制。

## [What is a NURBS?](http://www.rw-designer.com/NURBS)

### Bézier curves

Before explaining NURBS, we will stop by Bézier curve, because **NURBS is a generalization of Bézier curve**. The following figure shows a simple Bézier curve (C), its control points (1), (2), (3), (4), and its control polygon (P). The control points are also called control handles.

Each point on a Bézier curve (and on many other kinds of curves) is computed as a weighted sum of all control points. This means that each point is influenced by every control point. The first control point has maximum impact on the beginning of the curve, the second one reaches its maximum in the first half of the curve, etc.

Each control point influences the final curve according to assigned blending function. A blending function defines the weight of the control point at each point of the curve. A value of 0 indicates that the control point is not affecting a point on the curve. If the blending function reaches 1, the curve is (usually) intersecting the control point.

Properties of blending functions define properties of a curve. Bézier curves use polynomial functions of given degree. The resulting curves have these properties:

- The curve starts in the first control point, ends in the last control point, but in general case does not cross the inner control points.
- The tangent of the curve in its ending points is controlled by the inner control points.
- The curve is always inside the convex hull of the control polygon.

### Curve degree

The previous example showed a cubic (degree 3) curve, which is one of the most often used types. The **degree refers to the highest exponent** in the polynomial blending functions used for Bézier curves. A Bézier curve may be of arbitrary degree. **A degree 1 curve is a simple line and has two control points**. A degree 2 curve is an arc and has three control points. The higher the degree, the more control points and the more complex shape is possible. But it is also more much harder to use, because each control point still influences the whole curve.

### Rational curves

Each control point in rational curve is assigned a weight. The weight defines how much does a point "attract" the curve. Only the relative weights of the control points are important, not their absolute values. A curve with all weights set to 1 will have the same shape as if all weights are set to 100. The shape only changes if weights of control points are different.

Ordinary Bézier curve is a special case of rational Bézier curve, where all weights are equal. Rational curve gives designers additional options at the cost of a more complicated algorithm and additional data to keep track of.

### B-Splines

A B-Spline consists of multiple Bézier arcs and **provides an unified mechanism how to define continuity in the joins**.

Consider two cubic Bézier curves - that is 8 total control points (4 per curve).

Lets make the last point of the first (green) curve equal to the first point of the second (violet) curve - this saves us 1 point leaving us with 7 total control points. **We have replaced one control point with an external condition**.

The third (blue) curve and the fourth (yellow) curve share ending points just like in previous case, but they also have the same tangent direction at the junction point. **There are two external conditions and only 6 control points are necessary** to describe the curves.

**B-Splines use external conditions to put multiple pieces together while keeping the original concept of control points**. **The neighbor curves share some control points**. **External conditions are either implicit (uniform curves) or explicitly given by a knot vector**. **Knot vector defines how much information should be shared by neighbor curves (segments)**.

Knot vector is a sequence of numbers, usually from 0 to 1, for example (0, 0.5, 0.5, 0.7, 1), and it holds the information about external conditions mentioned earlier. Number of intervals defines number of segments (3 in our case: 0-0.5, 0.5-0.7, 0.7-1). Numbers in knot vector are called knots and each knot has its multiplicity. Multiplicity of knot 0.7 is 1, while multiplicity of knot 0.5 is 2. The higher the multiplicity, the less information share the neighbor segments. When multiplicity is equal to the degree of used curves, there is a sharp edge (green and violet curves on the image).

### NURBS

NURBS stands for Non-Uniform Rational B-Spline. It means NURBS uses rational Bézier curves and an **non-uniform explicitly given knot vector**. Therefore, degree, control points, weights, and knot vector are needed to specify a NURBS curve.

## [Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)

...


