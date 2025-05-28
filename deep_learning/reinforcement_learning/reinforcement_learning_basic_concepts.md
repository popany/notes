# Basic Concepts in Reinforcement learning

- [Basic Concepts in Reinforcement learning](#basic-concepts-in-reinforcement-learning)
  - [Episode](#episode)
    - [强化学习中的Episode（情节）](#强化学习中的episode情节)
    - [主要特点](#主要特点)
    - [示例说明](#示例说明)
    - [Episode与Step的关系](#episode与step的关系)

## Episode

### 强化学习中的Episode（情节）

在强化学习中，**episode**（情节）是指智能体（agent）与环境（environment）交互的一个完整序列，从初始状态开始，到达终止状态结束。它是学习和训练过程的基本单位。

### 主要特点

- **完整性**：代表一次完整的任务尝试，有明确的起点和终点
- **有限长度**：每个episode都会结束，但不同episode的长度可能不同
- **状态重置**：一个episode结束后，环境会被重置到初始状态，开始新的episode

### 示例说明

| 应用场景 | Episode的具体含义 |
|---------|-----------------|
| 游戏 | 一局完整的游戏（从开始到胜利/失败） |
| 机器人导航 | 从起点到目标点的完整路径 |
| 棋类游戏 | 一盘完整的对弈 |
| 自动驾驶模拟 | 一次完整的行程（从起点到目的地） |

### Episode与Step的关系

- **Step（步骤）**：单次动作和环境反馈的交互
- **Episode**：由多个连续steps组成的序列
- 关系：一个episode包含多个steps，episode结束后会重新开始新的episode

在很多强化学习算法中（如蒙特卡洛方法），智能体需要完成多个episodes来收集经验并优化其策略，逐步提高性能。



