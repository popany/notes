# [RL — LQR & iLQR Linear Quadratic Regulator](https://jonathan-hui.medium.com/rl-lqr-ilqr-linear-quadratic-regulator-a5de5104c750)

- [RL — LQR & iLQR Linear Quadratic Regulator](#rl--lqr--ilqr-linear-quadratic-regulator)
  - [Example](#example)

Model-based learning, on the contrary, develops a **model** (the system dynamics) to optimize controls. Mathematically, **the model $f$ predicts the next state when taken an action $u$ from a state $x$**.

$\textbf{x}_{t+1} = f\left(\textbf{x}_{t}, \textbf{u}_{t}\right)$

Linear Quadratic Regulator LQR and iLQR calculate an optimal trajectory from the **initial** to the **target state** by optimizing a cost function.

$\min\limits_{\textbf{u}_{1},...,\textbf{u}_{T}} \displaystyle\sum_{t=1}^{T} c\left( \textbf{x}_{t}, \textbf{u}_{t} \right) s.t. \textbf{x}_{t} = f\left(\textbf{x}_{t-1}, \textbf{u}_{t-1}\right)$

## Example

Our state may compose of the location and the velocity in the x and y-direction of an object.

$\textbf{x}_t = \left(px_{t}, vx_{t}, py_{t}, vy_{t}\right)$

Our actions are the forces applied.

$\textbf{u}_{t} = \left(Fx_{t}, Fy_{t}\right)$

The objective below minimizes the amount of force applied.

$minimize \frac{\|\textbf{u}_{1}\|^{2} + \cdots + \|\textbf{u}_{T-1}\|^{2}}{c}$

But this is not very interesting. We can add another term to penalize the system if it deviates from a planned trajectory.

$minimize \displaystyle\sum_{t=2}^{T}\|\textbf{y}_{t} - \textbf{y}_{t}^{des}\|^{2} + \rho \displaystyle\sum_{t=1}^{T-1}\|\textbf{u}_{t}\|^{2}, s.t. x$



