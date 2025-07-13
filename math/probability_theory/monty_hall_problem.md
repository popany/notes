# Monty Hall problem

- [Monty Hall problem](#monty-hall-problem)
  - [原问题](#原问题)
  - [用一个更加普遍的情况来理解](#用一个更加普遍的情况来理解)

## 原问题

https://en.wikipedia.org/wiki/Monty_Hall_problem

## 用一个更加普遍的情况来理解

对于更普遍的情况，如果有 $n$ 个门, $n-1$ 个羊和 $1$ 个车。当你选择一个门后，主持人会从另外 $n-1$ 个门中打开一个门，并让你看到结果是一只羊，问你是否会改变你的选择？

解：

定义事件 $A$ 为你选中了车，$P(A)$ 为事件 $A$ 的概率。
定义事o $B$ 为主持人选中了羊，$P(B)$ 为事件 $B$ 的概率。

分两种情况讨论

1. 若主持人随机选择门，则

$$
P(B) = P(B|A)P(A) + P(B|\overline{A})P(B|\overline{A}) = \frac{1}{n} + \frac{n-2}{n-1}\frac{n-1}{n} = \frac{1}{n} + \frac{n-2}{n}=\frac{n-1}{n}
$$

且考虑

$$
P(AB) = P(B|A)P(A) = \frac{1}{n}
$$

则

$$
P(A|B) = \frac{P(AB)}{P(B)} = \frac{\frac{1}{n}}{\frac{n-1}{n}} = \frac{1}{n - 1}
$$

即，此时剩下的 $n-2$ 个门中有车的概率为 $\frac{n-2}{n-1}$，而如果你此时放弃最初的选择，改为从 $n-2$ 个门中选，那么你选中车的概率为 $\frac{n-2}{n-1}\frac{1}{n-2}$ 依然为 $\frac{1}{n-1}$

2. 若主持人知道哪个门后面是车，且故意选中羊

那么，$B$ 为必然事件，$P(B) = 1$。

则

$$
P(A|B) = \frac{P(AB)}{P(B)} = \frac{\frac{1}{n}}{1} = \frac{1}{n}
$$

即，此时剩下的 $n-2$ 个门中有车的概率为 $\frac{n-1}{n}$，而如果你此时放弃最初的选择，改为从 $n-2$ 个门中选，那么你选中车的概率为 $\frac{n-1}{n}\frac{1}{n-2}$ 大于最初选则的概率 $\frac{1}{n}$。

