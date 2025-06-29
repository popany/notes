# Euler Angle

- [Euler Angle](#euler-angle)
  - [Euler Angle Definition](#euler-angle-definition)
    - [Definition by intrinsic rotations](#definition-by-intrinsic-rotations)
    - [Definition by extrinsic rotations](#definition-by-extrinsic-rotations)
  - [References](#references)

The Euler angles are three angles introduced by Leonhard Euler to describe the orientation of a rigid body with respect to a fixed coordinate system.

Euler angles can be defined by elemental geometry or by composition of rotations (i.e. [chained rotations](https://en.wikipedia.org/wiki/Davenport_chained_rotations)). The geometrical definition demonstrates that three consecutive elemental rotations (rotations about the axes of a coordinate system) are **always sufficient to reach any target frame**.

The three elemental rotations may be **extrinsic** (rotations about the axes xyz of the original coordinate system, which is assumed to remain motionless), or **intrinsic** (rotations about the axes of the rotating coordinate system XYZ, solidary with the moving body, which changes its orientation with respect to the extrinsic frame after each elemental rotation).

> 注：  
> intrinsic rotations: 本体旋转
> extrinsic rotations: 外体旋转

Euler angles are typically denoted as α, β, γ, or ψ, θ, φ. Different authors may use different sets of rotation axes to define Euler angles, or different names for the same angles. Therefore, any discussion employing Euler angles should always be preceded by their definition.

Without considering the possibility of using two different conventions for the definition of the rotation axes (intrinsic or extrinsic), there exist twelve possible sequences of rotation axes, divided in two groups:

- Proper Euler angles (z-x-z, x-y-x, y-z-y, z-y-z, x-z-x, y-x-y)
- Tait–Bryan angles (x-y-z, y-z-x, z-x-y, x-z-y, z-y-x, y-x-z).

## Euler Angle Definition 

### Definition by intrinsic rotations

Intrinsic rotations are elemental rotations that occur about the axes of a coordinate system XYZ attached to a moving body. Therefore, they change their orientation after each elemental rotation. The XYZ system rotates, while xyz is fixed. Starting with XYZ overlapping xyz, a composition of three intrinsic rotations can be used to reach any target orientation for XYZ.

Euler angles can be defined by intrinsic rotations. The rotated frame XYZ may be imagined to be initially aligned with xyz, before undergoing the three elemental rotations represented by Euler angles. Its successive orientations may be denoted as follows:

- x-y-z or x0-y0-z0 (initial)
- x′-y′-z′ or x1-y1-z1 (after first rotation)
- x″-y″-z″ or x2-y2-z2 (after second rotation)
- X-Y-Z or x3-y3-z3 (final)

Euler angles can be defined as follows:

- $\alpha$ (or $\phi$) represents a rotation around the $x$ axis,
- $\beta$ (or $\theta$) represents a rotation around the $y'$ axis,
- $\gamma$ (or $\psi$) represents a rotation around the $z''$ axis.

> 注：  
> 上面使用了旋转轴顺序约定 x-y-z，属于 "Tait–Bryan angles"。  
> 对于本体旋转，使用欧拉角计算坐标系 X-Y-Z 与坐标系 x-y-z 间的转换关系是比较好理解的。  
> 对于任一点 $p$, 设：点 $p$ 在坐标系 x-y-z 中的坐标为 $p_{0}$，在坐标系 x'-y'-z' 中的坐标为 $p_{1}$，在坐标系 x''-y''-z'' 中的坐标为 $p_{2}$，在坐标系 X-Y-Z 中的坐标为 $p_{3}$。   
> 坐标系 X-Y-Z 与坐标系 x-y-z 间的转换关系可定义为旋转矩阵 $R$，满足：$p_{0} = R p_{3}$  
> 根据本体旋转定义以及上面的旋转轴顺序约定，由于坐标系 X-Y-Z 为坐标系 x''-y''-z'' 绕轴 z'' 旋转 $\gamma$ 所得，则有：  
> $p_{2} = R''_{z''}(\gamma) p_{3}$，
${\displaystyle {\begin{alignedat}{1}R''_{z''}(\gamma )&={\begin{bmatrix}\cos \gamma &-\sin \gamma &0\\[3pt]\sin \gamma &\cos \gamma &0\\[3pt]0&0&1\\\end{bmatrix}}\end{alignedat}}}$  
同理：  
$p_{1}=R'_{y'}(\beta) p_{2}$，
${\displaystyle {\begin{alignedat}{1}R'_{y'}(\beta )&={\begin{bmatrix}\cos \beta &0&\sin \beta \\[3pt]0&1&0\\[3pt]-\sin \beta &0&\cos \beta \\\end{bmatrix}}\end{alignedat}}}$  
$p_{0}=R_{x}(\alpha)p_{1}$，
> ${\displaystyle {\begin{alignedat}{1}R_{x}(\alpha )&={\begin{bmatrix}1&0&0\\0&\cos \alpha &-\sin \alpha \\[3pt]0&\sin \alpha &\cos \alpha \\[3pt]\end{bmatrix}}\end{alignedat}}}$  
整合上述，则有：  
$p_{0} = R_{x}(\alpha)p_{1} = R_{x}(\alpha) R'_{y'}(\beta) p_{2} = R_{x}(\alpha) R'_{y'}(\beta) R''_{z''}(\gamma) p_{3}$  
$R = R_{x}(\alpha) R'_{y'}(\beta) R''_{z''}(\gamma)$
> $$
> {\displaystyle {\begin{alignedat}{1}R&={\begin{bmatrix}\cos \beta \cos \gamma & -\cos \beta \sin \gamma & \sin \beta \\[3pt] \sin \alpha \sin \beta \cos \gamma + \cos \alpha \sin \gamma & -\sin \alpha \sin \beta \sin \gamma + \cos \alpha \cos \gamma & -\sin \alpha \cos \beta \\[3pt] -\cos \alpha \sin \beta \cos \gamma + \sin \alpha \sin \gamma & \cos \alpha \sin \beta \sin \gamma + \sin \alpha \cos \gamma & \cos \alpha \cos \beta \\\end{bmatrix}}\end{alignedat}}}
> $$

### Definition by extrinsic rotations

Extrinsic rotations are elemental rotations that occur about the axes of the fixed coordinate system xyz. The XYZ system rotates, while xyz is fixed. Starting with XYZ overlapping xyz, a composition of three extrinsic rotations can be used to reach any target orientation for XYZ. The Euler or Tait–Bryan angles ($\alpha$, $\beta$, $\gamma$) are the amplitudes of these elemental rotations. 

我们讨论任一点 $p$ 在坐标系 $xyz$ 中的坐标与在坐标系 $XYZ$ 中的坐标的转换关系。其中坐标系 $XYZ$ 定义为初始坐标轴与 $xyz$ 的坐标轴重合，后将 $XYZ$ 的坐标轴分别绕坐标系 $xyz$ 的轴 $x$、$y$、$z$ 旋转角度 $\alpha$、$\beta$、$\gamma$ 所得。

如此所得的 $xyz$ 坐标轴与 $XYZ$ 坐标轴的相对关系等效于保持 $XYZ$ 的初始坐标轴不变，将坐标系 $xyz$ 的坐标轴分别绕 $x$、$y$、$z$ 旋转角度 $-\alpha$、$-\beta$、$-\gamma$。

设坐标系 $xyz$ 绕 $x$ 轴旋转 $-\alpha$ 后所得坐标系为 $x'y'z'$，绕 $x'y'z'$ 的坐标轴 $y'$ 旋转 $-\beta$ 后所得坐标系为 $x''y''z''$，绕 $x''y''z''$ 的坐标轴 $z''$ 旋转 $-\gamma$ 后所得坐标系为 $x'''y'''z'''$。

设点 $p$ 在坐标系 $XYZ$ 中的坐标为：$p_0$，在坐标系 $x'y'z'$ 中的坐标为 $p_1$，在坐标系 $x''y''z''$ 中的坐标为 $p_2$，在坐标系 $x'''y'''z'''$ 中的坐标为 $p_3$，则有以下关系：

$R_{x}(-\alpha) p_1 = p_0$  
$R'_{y'}(-\beta) p_2 = p_1$  
$R''_{z''}(-\gamma) p_3 = p_2$

可得：

$R_{x}(-\alpha) R'_{y'}(-\beta) R''_{z''}(-\gamma) p_3 = p_0$  
$p_3 = R''_{z''}(\gamma) R'_{y'}(\beta) R_{x}(\alpha) p_0$

其中 $p_3$ 为点 $p$ 在坐标系 $xyz$ 中的坐标，$p_0$ 为点 $p$ 在坐标系 $XYZ$ 中的坐标。定义 $\alpha$、$\beta$、$\gamma$ 为欧拉角。

按欧拉角以 x-y-z 顺序外体旋转所得坐标系到原坐标系的旋转矩阵为：

$R_{z}(\gamma) R_{y}(\beta) R_{x}(\alpha)$

对比以 x-y-z 顺序本体旋转所得坐标系与原坐标系的旋转矩阵：

$R_{x}(\alpha) R_{y}(\beta) R_{z}(\gamma)$

本体旋转和外体旋转的欧拉角与旋转顺序都是反的。

## References

https://en.wikipedia.org/wiki/Euler_angles

https://en.wikipedia.org/wiki/Davenport_chained_rotations

https://en.wikipedia.org/wiki/Rotation_matrix

