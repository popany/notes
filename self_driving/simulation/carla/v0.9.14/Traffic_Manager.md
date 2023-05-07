# [Traffic Manager](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/)

- [Traffic Manager](#traffic-manager)
  - [What is the Traffic Manager?](#what-is-the-traffic-manager)
    - [Structured design](#structured-design)
    - [User customization](#user-customization)
  - [Architecture](#architecture)
    - [Overview](#overview)

## What is the Traffic Manager?

The Traffic Manager (TM) is the module that controls vehicles in autopilot mode in a simulation. Its goal is to populate a simulation with realistic urban traffic conditions. Users can customize some behaviors, for example, to set specific learning circumstances.

### Structured design

TM is built on CARLA's client-side. The execution flow is divided into **stages**, each with independent operations and goals. This facilitates the development of phase-related functionalities and data structures while improving computational efficiency. Each stage runs on a different thread. Communication with other stages is managed through synchronous messaging. Information **flows in one direction**.

### User customization

Users have some control over the traffic flow by setting parameters that allow, force, or encourage specific behaviors. Users can change the traffic behavior as they prefer, both online and offline. For example, cars can be allowed to ignore the speed limits or force a lane change. Being able to play around with behaviors is indispensable when trying to simulate reality. Driving systems need to be trained under specific and atypical circumstances.

## Architecture

### Overview

The above diagram is a representation of the internal architecture of the TM. The C++ code for each component can be found in `LibCarla/source/carla/trafficmanager`. Each component is explained in detail in the following sections. A simplified overview of the logic is as follows:








