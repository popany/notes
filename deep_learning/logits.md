# logits

- [logits](#logits)
  - [Resources](#resources)
  - [logits是什么意思？](#logits是什么意思)
    - [使用logits的常见场景](#使用logits的常见场景)
    - [例子](#例子)
    - [重要性](#重要性)

## Resources

[Interpreting logits: Sigmoid vs Softmax](https://web.stanford.edu/~nanbhas/blog/sigmoid-softmax/)

## logits是什么意思？

"Logits"是机器学习和统计学中的一个术语，通常出现在分类任务中，尤其是二分类或多分类问题。它指的是神经网络输出层的未经过激活函数处理的值。具体来说，logits是模型的线性变换（如线性回归中的加权和）后的结果，它们还没有通过Softmax或Sigmoid函数等非线性激活函数转换成概率。

在神经网络中，logits的计算通常如下：

1. 输入特征通过一系列隐藏层的处理，每一层的输出被称为特征或表示。

2. 最后一层（输出层）进行线性变换（通常是一个线性映射），生成logits。

### 使用logits的常见场景

1. Softmax回归（多分类问题）：

   - Softmax函数将logits转换成概率分布，这些概率表示输入属于每个类别的概率。

   - Logits在这里表示每个类别的未归一化的得分。

2. Sigmoid回归（二分类问题）：

   - Sigmoid函数将单个logit转换成概率（取值范围在0到1之间）。

   - Logits表示输入属于某个类别的未归一化得分。

### 例子

假设我们有一个三分类问题，模型的输出层有3个神经元，分别对应类别A、B和C。假设经过最后一层的线性变换后得到的logits是[2.0, -1.0, 0.5]。

这些logits还不是概率，我们需要通过Softmax函数将它们转换成概率：

$Softmax(z_{i})=\frac{e^{z_{i}}}{\Sigma_{j}e^{z_{j}}}$

计算得到的概率可能是[0.7, 0.05, 0.25]，表示输入样本属于类别A、B和C的概率。

### 重要性

使用logits的主要原因是它们在数学计算和优化过程中更方便。例如，在训练神经网络时，交叉熵损失函数（Cross-Entropy Loss）通常直接使用logits而不是概率，这样在计算梯度时更为高效和稳定。

总结来说，logits是神经网络模型中用于表示分类得分的中间结果，在转换成概率之前的那一步。这些值在优化过程中有其独特的重要性。
