# Q-learning

- [Q-learning](#q-learning)
  - [Reinforcement learning](#reinforcement-learning)
  - [Algorithm](#algorithm)
  - [Influence of variables](#influence-of-variables)
    - [Learning rate](#learning-rate)
    - [Discount factor](#discount-factor)
    - [Initial conditions ($Q\_0$)](#initial-conditions-q_0)
  - [Implementation](#implementation)
    - [Function approximation](#function-approximation)
    - [Quantization](#quantization)
  - [History](#history)
  - [Variants](#variants)
    - [Deep Q-learning](#deep-q-learning)
    - [Double Q-learning](#double-q-learning)
    - [Others](#others)
    - [Multi-agent learning](#multi-agent-learning)
  - [Limitations](#limitations)

Q-learning是一种强化学习算法，训练智能体基于其当前状态为可能的动作分配值，而无需环境模型(即无模型)。它能够处理具有随机转换和奖励的问题，而不需要特别调整。

以网格迷宫为例，智能体学习到达价值10分的出口。在一个交叉路口：
- Q-learning可能会为向右移动分配比向左移动更高的值，如果向右能更快到达出口
- 通过随时间推移尝试两个方向，智能体会不断改进其选择

对于任何有限马尔可夫决策过程，Q-learning能找到一个最优策略，即从当前状态开始，最大化所有后续步骤总奖励的期望值。给定无限探索时间和部分随机策略，Q-learning能为任何给定的有限马尔可夫决策过程识别出最优动作选择策略。

"Q"指的是算法计算的函数：在给定状态下采取特定动作的期望奖励——即动作的质量(quality)。

## Reinforcement learning

强化学习涉及三个基本要素：
- **智能体**(agent)
- **状态集合** $\mathcal{S}$
- **每个状态的动作集合** $\mathcal{A}$

通过执行动作 $a \in \mathcal{A}$，智能体从一个状态转移到另一个状态，并获得奖励(数值分数)。

智能体的目标是**最大化其总奖励**。实现方式是：
- 将未来状态可获得的最大奖励添加到当前状态的奖励中
- 通过潜在的未来奖励影响当前动作决策
- 考虑从当前状态开始的所有未来步骤奖励的加权期望和

以登火车为例，奖励是登车总时间的负值(或者说，登车成本等于登车时间)：

**策略1(不耐心)**：
- 行动：门一开就立即进入
- 初始等待时间：0秒
- 与下车乘客争抢时间：15秒
- 总时间(成本)：0 + 15 = 15秒

**策略2(有耐心)**：
- 行动：等待并让其他人先下车
- 初始等待时间：5秒
- 与下车乘客争抢时间：0秒
- 总时间(成本)：5 + 0 = 5秒

通过探索，尽管初始(耐心)行动导致比强行策略更大的成本(或负奖励)，但总体成本更低，从而揭示了一种更有回报的策略。这正是强化学习通过探索和长期规划发现最优策略的方式。

## Algorithm

在强化学习中，当智能体考虑 $\Delta t$ 步之后的未来，它会决定下一步行动。这一未来步骤的权重被计算为 $\gamma^{\Delta t}$，其中：

- $\gamma$ 是**折现因子**(discount factor)
- $\gamma$ 的取值范围是0到1之间 ($0 \leq \gamma \leq 1$)

当 $\gamma < 1$ 时，它产生两个关键效果：

1. **时间偏好**：使较早获得的奖励比较晚获得的奖励具有更高的价值(反映"良好开端"的价值)

2. **生存概率解释**：$\gamma$ 也可以被解释为智能体在每一步 $\Delta t$ 成功(或生存)的概率

**实际应用**

- $\gamma$ 接近0：智能体更加"近视"，几乎只考虑即时奖励
- $\gamma$ 接近1：智能体更加"远见"，几乎同等重视近期和远期奖励
- 适当的 $\gamma$ 值选择有助于平衡短期收益与长期规划

Q-learning算法有一个函数来计算状态-动作组合的质量：

$$Q: \mathcal{S} \times \mathcal{A} \to \mathbb{R}$$

在学习开始前，$Q$ 被初始化为可能是任意的固定值(由程序员选择)。

在每个时间 $t$：
1. 智能体选择动作 $A_t$
2. 观察奖励 $R_{t+1}$
3. 进入新状态 $S_{t+1}$ (可能依赖于先前状态 $S_t$ 和所选动作)
4. 更新 $Q$ 值

算法的核心是一个简单的值迭代更新的贝尔曼方程，使用当前值和新信息的加权平均：

$${\displaystyle Q^{new}(S_{t},A_{t})\leftarrow (1-\underbrace {\alpha } _{\text{learning rate}})\cdot \underbrace {Q(S_{t},A_{t})} _{\text{current value}}+\underbrace {\alpha } _{\text{learning rate}}\cdot {\bigg (}\underbrace {\underbrace {R_{t+1}} _{\text{reward}}+\underbrace {\gamma } _{\text{discount factor}}\cdot \underbrace {\max _{a}Q(S_{t+1},a)} _{\text{estimate of optimal future value}}} _{\text{new value (temporal difference target)}}{\bigg )}}$$

> discount factor: 折现因子
> temporal difference target: 时间差分目标

其中：
- $R_{t+1}$ 是从状态 $S_t$ 移动到状态 $S_{t+1}$ 时获得的奖励
- $\alpha$ 是学习率 $(0 < \alpha \leq 1)$

$Q^{new}(S_t,A_t)$ 是三个因素的总和：

1. $(1-\alpha)Q(S_t,A_t)$：当前值(由1减去学习率加权)
2. $\alpha R_{t+1}$：在状态 $S_t$ 采取动作 $A_t$ 获得的奖励(由学习率加权)
3. $\alpha\gamma\max_a Q(S_{t+1},a)$：从状态 $S_{t+1}$ 可以获得的最大奖励(由学习率和折现因子加权)

算法的一个情节在状态 $S_{t+1}$ 为最终或终止状态时结束。
Q-learning也可以在非情节任务中学习(收敛无限级数的特性)。
如果折现因子小于1，即使问题可能包含无限循环，动作值也是有限的。

对于所有最终状态 $s_f$：
- $Q(s_f,a)$ 永远不会更新，而是设置为状态 $s_f$ 观察到的奖励值 $r$
- 在大多数情况下，$Q(s_f,a)$ 可以设为零

## Influence of variables

### Learning rate

**学习率**(learning rate)或**步长**(step size)决定了新获取信息覆盖旧信息的程度：

- **α = 0**：智能体什么都不学习(完全依赖先验知识进行利用)
- **α = 1**：智能体只考虑最新信息(忽略先验知识以探索可能性)

**不同环境中的最优设置**

- **确定性环境**：在完全确定性环境中，学习率 $\alpha_t = 1$ 是最优的
- **随机环境**：当问题是随机的，在一些关于学习率的技术条件下(要求其随时间减小至零)，算法才能收敛

在实践中，通常使用恒定的学习率，例如对所有时间步 $t$ 都使用 $\alpha_t = 0.1$。这种做法虽然在理论上可能不保证收敛，但在许多应用中表现良好且实现简单。

### Discount factor

折扣因子 $\gamma$ 决定了未来奖励的重要性。 折扣因子为 0 会使智能体变得“短视”，因为它只考虑当前的奖励，即 $r_{t}$ (在上面的更新规则中)，而接近 1 的因子会使其努力争取长期的较高奖励。 如果折扣因子等于或超过 1，则动作值可能会发散。 对于 $\gamma = 1$，如果没有终止状态，或者如果智能体永远无法达到终止状态，则所有的环境历史都会变得无限长，并且具有可加的、未折扣奖励的效用通常会变得无限大。 即使折扣因子仅略低于 1，当价值函数用人工神经网络近似时，Q 函数学习也会导致误差的传播和不稳定性。 在这种情况下，从较低的折扣因子开始，并将其增加到最终值会加速学习。

### Initial conditions ($Q_0$)

由于 Q-learning 是一种迭代算法，它在第一次更新发生之前隐式地假定了一个初始条件。 较高的初始值，也称为“乐观的初始条件”，可以鼓励探索：无论选择哪个动作，更新规则都会导致它的值低于其他备选项，从而增加其他选项的选择概率。 第一个奖励 $r$ 可以用于重置初始条件。 根据这个想法，第一次采取某个动作时，奖励被用来设置 $Q$ 的值。 这允许在固定确定性奖励的情况下进行即时学习。 一个预计纳入初始条件重置 (Reset of Initial Conditions, RIC) 的模型，预计比一个假设任意初始条件 (Arbitrary Initial Condition, AIC) 的模型，能更好地预测参与者的行为。 RIC 似乎与人类在重复的二元选择实验中的行为相一致。

## Implementation

最简单的 Q-learning 将数据存储在表格中。 随着状态/动作数量的增加，这种方法会变得力不从心，因为智能体访问特定状态并执行特定动作的可能性变得越来越小。

### Function approximation

Q-learning 可以与函数近似相结合。 这使得将该算法应用于更大的问题成为可能，即使在状态空间是连续的情况下也是如此。

一种解决方案是使用（经过调整的）人工神经网络作为函数近似器。 另一种可能性是整合模糊规则插值 (Fuzzy Rule Interpolation, FRI) 并使用稀疏模糊规则库来代替离散的 Q 表格或人工神经网络，这样做的好处是它是一种人类可读的知识表示形式。 由于该算法可以将早期的经验推广到以前未见过的状态，函数近似可以加速有限问题中的学习。

### Quantization

另一种减少状态/动作空间的技术是对可能的值进行**量化**。 以学习在手指上平衡杆子为例。 为了描述某个时间点的状态，需要考虑手指在空间中的位置、它的速度、杆子的角度以及杆子的角速度。 这会得到一个四元素向量，用来描述一个状态，即一个状态的快照被编码成四个数值。 问题在于存在无限多的可能状态。 为了缩小有效动作的可能空间，可以将多个值分配到一个“桶”（bucket）中。 例如，我们不关心手指距离起始位置的精确距离（从负无穷到正无穷），而是关心它是否远离起始位置（例如，“近”或 “远”）。

## History

...

## Variants

### Deep Q-learning

DeepMind 系统使用了一个深度卷积神经网络，其结构包括多层平铺的卷积滤波器，以模拟感受野（receptive fields）的效果。在使用神经网络等非线性函数逼近方法来表示 Q 值时，强化学习往往会变得不稳定，甚至发散。这种不稳定性来源于观测序列中存在的相关性、小幅度的 Q 值更新可能会显著改变智能体的策略和数据分布，以及 Q 值与目标值之间的相关性。该方法可用于在各种领域和应用中的随机搜索。

这一技术使用了“经验回放”（experience replay），这是一种受生物机制启发的方法，通过从以往动作中随机采样，而不是仅使用最近的动作来进行学习。这样可以打破观测序列中的相关性，并平滑数据分布的变化。通过迭代更新，Q 值逐步向目标值靠拢，而目标值本身只会在一定时间间隔后才更新一次，从而进一步减少与目标之间的相关性。

### Double Q-learning

由于在 Q 学习（Q-learning）中，对未来最大动作值的估计和当前动作选择策略使用的是同一个 Q 函数，因此在存在噪声的环境中，Q 学习有时会高估动作的价值，从而导致学习过程变慢。为了解决这一问题，研究人员提出了一种变体，称为双重 Q 学习（Double Q-learning）。双重 Q 学习是一种离策略（off-policy）的强化学习算法，其中用于评估价值的策略与用于选择下一个动作的策略不同。

在实践中，该方法训练两个互相对称的独立价值函数：$Q^A$ 和 $Q^B$，它们分别使用独立的经验数据进行训练。双重 Q 学习的更新步骤如下：

$$
Q_{t+1}^A(s_t, a_t) = Q_t^A(s_t, a_t) + \alpha_t(s_t, a_t) \left[ r_t + \gamma \cdot Q_t^B\left(s_{t+1}, \arg\max_a Q_t^A(s_{t+1}, a) \right) - Q_t^A(s_t, a_t) \right]
$$

$$
Q_{t+1}^B(s_t, a_t) = Q_t^B(s_t, a_t) + \alpha_t(s_t, a_t) \left[ r_t + \gamma \cdot Q_t^A\left(s_{t+1}, \arg\max_a Q_t^B(s_{t+1}, a) \right) - Q_t^B(s_t, a_t) \right]
$$

在这个算法中，对未来折扣回报（discounted future return）的估计是使用不同的策略来进行的，从而有效避免了高估问题。

该算法在 2015 年被进一步改进并与深度学习相结合，形成了 Double DQN（双重深度 Q 网络）算法。Double DQN 的表现优于原始的 DQN 算法。

### Others

延迟 Q 学习（Delayed Q-learning）是一种在线 Q 学习算法的替代实现，它具备“可能近似正确”（PAC, Probably Approximately Correct）学习的理论保证。

Greedy GQ 是 Q 学习的一种变体，它可以与（线性）函数逼近方法结合使用。Greedy GQ 的优势在于，即使使用函数逼近来估计动作值，其收敛性仍然可以得到保证。

分布式 Q 学习（Distributional Q-learning）是 Q 学习的一种变体，其目标是建模每个动作回报的分布，而不仅仅是期望回报。研究发现，分布式 Q 学习更适合与深度神经网络结合使用，并且可以支持一些替代的控制方法，例如风险敏感型控制（risk-sensitive control）。

### Multi-agent learning

Q 学习（Q-learning）已被扩展应用于多智能体（multi-agent）环境中。一种方法是假设环境是被动的（passive），即每个智能体将其他智能体的行为视为环境的一部分来处理。Littman 提出了极小极大 Q 学习算法（Minimax Q-learning algorithm）。

## Limitations

标准的 Q 学习算法（使用 Q 表）仅适用于离散的动作空间和状态空间。对连续状态或动作进行离散化处理会导致学习效率低下，这主要是由于“维度灾难”（curse of dimensionality）所引起的。然而，已经出现了一些对 Q 学习的改进方法，试图解决这一问题，例如“线性拟合神经网络 Q 学习”（Wire-fitted Neural Network Q-Learning）。
