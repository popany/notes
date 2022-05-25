# [Trajectory Planning in the Frenet Space](https://fjp.at/posts/optimal-frenet/)

- [Trajectory Planning in the Frenet Space](#trajectory-planning-in-the-frenet-space)
  - [Algorithm](#algorithm)

There are many ways to plan a trajectory for a robot. A trajectory can be seen as a set of time ordered state vectors $x$. The following algorithm introduces a way to plan trajectories to maneuver a mobile robot in a 2D plane. It is specifically useful for structured environments, like highways, where a rough path, referred to as reference, is available a priori.

## Algorithm

1. Determine the trajectory start state $[x_1,x_2,\theta,\kappa,v,a](0)$ The trajectory start state is obtained by evaluating the previously calculated trajectory at the prospective start state (low-level-stabilization). At system initialization and after reinitialization, the current vehicle position is used instead (high-level-stabilization).

2. Selection of the lateral mode Depending on the velocity $v$ the time based ($d(t)$) or running length / arc length based ($d(s)$) lateral planning mode is activated. By projecting the start state onto the reference curve the the longitudinal start position $s(0)$ is determined. The frenet state vector $[s,\dot{s},\ddot{s},d,d',d''](0)$ can be determined using the frenet transformation. For the time based lateral planning mode, $[\dot{d}, \ddot{d}](0)$ need to be calculated.

3. Generating the laterl and longitudinal trajectories Trajectories including their costs are generated for the lateral (mode dependent) as well as the longitudinal motion (velocity keeping, vehicle following / distance keeping) in the frenet space. In this stage, trajectories with high lateral accelerations with respect to the reference path can be neglected to improve the computational performance.






TODO xxxxxx

