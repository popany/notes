# [RL — LQR & iLQR Linear Quadratic Regulator](https://jonathan-hui.medium.com/rl-lqr-ilqr-linear-quadratic-regulator-a5de5104c750)

- [RL — LQR & iLQR Linear Quadratic Regulator](#rl--lqr--ilqr-linear-quadratic-regulator)

Model-based learning, on the contrary, develops a **model** (the system dynamics) to optimize controls. Mathematically, **the model $f$ predicts the next state when taken an action $u$ from a state $x$**.

$\textbf{x}_{t+1} = f\left(\textbf{x}_{t}, \textbf{u}_{t}\right)$

Linear Quadratic Regulator LQR and iLQR calculate an optimal trajectory from the **initial** to the **target state** by optimizing a cost function.

$\min\limits_{\textbf{u}_{1},...,\textbf{u}_{T}} \displaystyle\sum_{t=1}^{T} c\left( \textbf{x}_{t}, \textbf{u}_{t} \right) s.t. \textbf{x}_{t} = f\left(\textbf{x}_{t-1}, \textbf{u}_{t-1}\right)$


