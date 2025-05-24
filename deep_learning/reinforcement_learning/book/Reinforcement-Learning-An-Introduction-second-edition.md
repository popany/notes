# [Reinforcement Learning An Introduction second edition](https://mitpress.mit.edu/9780262039246/reinforcement-learning/)

- [Reinforcement Learning An Introduction second edition](#reinforcement-learning-an-introduction-second-edition)
  - [Chapter 1 Introduction](#chapter-1-introduction)
    - [1.1 Reinforcement Learning](#11-reinforcement-learning)
    - [1.2 Examples](#12-examples)
    - [1.3 Elements of Reinforcement Learning](#13-elements-of-reinforcement-learning)

## Chapter 1 Introduction

The idea that we learn by interacting with our environment is probably the first to occur to us when we think about the nature of learning.

Learning from interaction is a foundational idea underlying nearly all theories of learning and intelligence.

In this book we explore a computational approach to learning from interaction.

### 1.1 Reinforcement Learning

Reinforcement learning is learning what to do-how to map situations to actions-so as to maximize a numerical reward signal. The learner is not told which actions to take, but instead must discover which actions yield the most reward by trying them. In the most interesting and challenging cases, actions may affect not only the immediate reward but also the next situation and, through that, all subsequent rewards. These two characteristics-trial-and-error search and delayed reward-are the two most important distinguishing features of reinforcement learning.

One of the challenges that arise in reinforcement learning, and not in other kinds of learning, is the trade-off between exploration and exploitation

### 1.2 Examples

...

### 1.3 Elements of Reinforcement Learning

Beyond the agent and the environment, one can identify four main subelements of a reinforcement learning system: a policy, a reward signal, a value function, and, optionally, a model of the environment.

A policy defines the learning agent’s way of behaving at a given time. Roughly speaking, a policy is a mapping from perceived states of the environment to actions to be taken when in those states. It corresponds to what in psychology would be called a set of stimulus–response rules or associations. In some cases the policy may be a simple function or lookup table, whereas in others it may involve extensive computation such as a search process. The policy is the core of a reinforcement learning agent in the sense that it alone is sufficient to determine behavior. In general, policies may be stochastic, specifying probabilities for each action.






