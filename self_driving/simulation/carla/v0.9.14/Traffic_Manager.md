# [Traffic Manager](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/)

- [Traffic Manager](#traffic-manager)
  - [What is the Traffic Manager?](#what-is-the-traffic-manager)
    - [Structured design](#structured-design)
    - [User customization](#user-customization)
  - [Architecture](#architecture)
    - [Overview](#overview)
      - [1. Store and update the current state of the simulation.](#1-store-and-update-the-current-state-of-the-simulation)
      - [2. Calculate the movement of every autopilot vehicle.](#2-calculate-the-movement-of-every-autopilot-vehicle)
      - [3. Apply the commands in the simulation.](#3-apply-the-commands-in-the-simulation)
    - [ALSM](#alsm)
    - [Vehicle registry](#vehicle-registry)
    - [Simulation state](#simulation-state)
    - [Control loop](#control-loop)
    - [In-Memory Map](#in-memory-map)
    - [PBVT](#pbvt)
    - [PID controller](#pid-controller)
    - [Command Array](#command-array)
    - [Stages of the Control Loop](#stages-of-the-control-loop)
      - [Stage 1- Localization Stage](#stage-1--localization-stage)
      - [Stage 2- Collision Stage](#stage-2--collision-stage)
      - [Stage 3- Traffic Light Stage](#stage-3--traffic-light-stage)
      - [Stage 4- Motion Planner Stage](#stage-4--motion-planner-stage)
      - [Stage 5- Vehicle Lights Stage](#stage-5--vehicle-lights-stage)
  - [Using the Traffic Manager](#using-the-traffic-manager)
    - [Vehicle behavior considerations](#vehicle-behavior-considerations)

## What is the Traffic Manager?

The Traffic Manager (TM) is the module that controls vehicles in autopilot mode in a simulation. Its goal is to populate a simulation with realistic urban traffic conditions. Users can customize some behaviors, for example, to set specific learning circumstances.

### Structured design

**TM is built on CARLA's client-side**. The execution flow is divided into **stages**, each with independent operations and goals. This facilitates the development of phase-related functionalities and data structures while improving computational efficiency. Each stage runs on a different thread. Communication with other stages is managed through synchronous messaging. Information **flows in one direction**.

### User customization

Users have some control over the traffic flow by setting parameters that allow, force, or encourage specific behaviors. Users can change the traffic behavior as they prefer, both online and offline. For example, cars can be allowed to ignore the speed limits or force a lane change. Being able to play around with behaviors is indispensable when trying to simulate reality. Driving systems need to be trained under specific and atypical circumstances.

## Architecture

### Overview

The above diagram is a representation of the internal architecture of the TM. The C++ code for each component can be found in `LibCarla/source/carla/trafficmanager`. Each component is explained in detail in the following sections. A simplified overview of the logic is as follows:

#### 1. Store and update the current state of the simulation.

- The [Agent Lifecycle & State Management](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#alsm) (ALSM) scans the world to keep track of all the vehicles and walkers present and to clean up entries for those that no longer exist. All the data is retrieved from the server and is passed through several [stages](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stages-of-the-control-loop). The ALSM is the only component that makes calls to the server.

- The [vehicle registry](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#vehicle-registry) contains an array of vehicles on autopilot (controlled by the TM) and a list of pedestrians and vehicles not on autopilot (not controlled by the TM).

- The [simulation state](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#simulation-state) is a cache store of the position, velocity, and additional information of all the vehicles and pedestrians in the simulation.

#### 2. Calculate the movement of every autopilot vehicle.

The TM generates **viable commands** for all vehicles in the [vehicle registry](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#vehicle-registry) according to the [simulation state](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#simulation-state). Calculations for each vehicle are done separately. These calculations are divided into different [stages](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stages-of-the-control-loop). The [control loop](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#control-loop) makes sure that all calculations are consistent by creating **synchronization barriers** between stages. No vehicle moves to the next stage before calculations are finished for all vehicles in the current stage. Each vehicle goes through the following stages:

- 2.1 - [Localization Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-1-localization-stage).

  Paths are created dynamically using a list of nearby **waypoints** collected from the [In-Memory Map](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#in-memory-map), a simplification of the simulation map as a **grid of waypoints**. Directions at junctions are chosen randomly. Each vehicle's path is stored and maintained by the [Path Buffers & Vehicle Tracking](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pbvt) (PBVT) component for easy access and modification in future stages.

- 2.2 - [Collision Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-2-collision-stage).

  Bounding boxes are extended over each vehicle's path to identify and navigate potential collision hazards.

- 2.3 - [Traffic Light Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-3-traffic-light-stage).

  Similar to the Collision Stage, potential hazards that affect each vehicle's path due to traffic light influence, stop signs, and junction priority are identified.

- 2.4 - [Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage).

  Vehicle movement is computed based on the defined path. A [PID controller](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pid-controller) determines how to reach the target waypoints. This is then **translated into a CARLA command** for application in the next step.

- 2.5 - [Vehicle Lights Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-5-vehicle-lights-stage).

  The vehicle lights switch on/off dynamically based on environmental factors (e.g. sunlight and the presence of fog or rain) and vehicle behavior (e.g. turning on direction indicators if the vehicle will turn left/right at the next junction, or turn on the stop lights if braking).

#### 3. Apply the commands in the simulation.

Commands generated in the previous step are collected into the command array and sent to the CARLA server in a **batch** to be applied in the **same frame**.

The following sections will explain each component and stage in the TM logic described above in more detail.

### ALSM

ALSM stands for **Agent Lifecycle and State Management**. It is the first step in the TM logic cycle and provides context of the simulation's current state.

The ALSM component:

- Scans the world to keep track of all vehicles and pedestrians, their positions and velocities. If physics are enabled, the velocity is retrieved by [`Vehicle.get_velocity()`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.Vehicle). Otherwise, the velocity is calculated using the history of position updates over time.

- Stores the position, velocity, and additional information (traffic light influence, bounding boxes, etc) of every vehicle and pedestrian in the [simulation state](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#simulation-state) component.

- Updates the list of TM-controlled vehicles in the [vehicle registry](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#vehicle-registry).

- Updates entries in the [control loop](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#control-loop) and [PBVT](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pbvt) components to match the vehicle registry.

Related .cpp files: `ALSM.h`, `ALSM.cpp`.

### Vehicle registry

The vehicle registry keeps track of all vehicles and pedestrians in the simulation.

The vehicle registry:

- Is passed an updated list of vehicles and pedestrians from the [ALSM](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#alsm).

- Stores vehicles registered to the TM in a separate array for iteration during the [control loop](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#control-loop).

Related .cpp files: `MotionPlannerStage.cpp`.

### Simulation state

The simulation state stores information about all vehicles in the simulation for easy access and modification in later stages.

The simulation state:

- Receives data from the [ALSM](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#alsm) including current actor position, velocity, traffic light influence, traffic light state, etc.

Stores all information in cache, avoiding subsequent calls to the server during the [control loop](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#control-loop).

Related .cpp files: `SimulationState.cpp`, `SimulationState.h`.

### Control loop

The control loop manages the calculations of the next command for all autopilot vehicles so they are performed synchronously. The control loop consists of five different [stages](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stages-of-the-control-loop); localization, collision, traffic light, motion planner and vehicle lights.

The control loop:

- Receives an array of TM-controlled vehicles from the [vehicle registry](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#vehicle-registry).

- Performs calculations for each vehicle separately by looping over the array.

- Divides calculations into a series of [stages](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stages-of-the-control-loop).

- Creates synchronization barriers between stages to guarantee consistency. Calculations for all vehicles are finished before any of them move to the next stage, ensuring all vehicles are updated in the same frame.

- Coordinates the transition between [stages](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stages-of-the-control-loop) so all calculations are done in sync.

- Sends the [command array](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#command-array) to the server when the last stages ([Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage) and [Vehicle Lights Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-5-vehicle-lights-stage)) finishes so there are no frame delays between the command calculations and the command application.

Related .cpp files: `TrafficManagerLocal.cpp`.

### In-Memory Map

The In-Memory Map is a helper module contained within the [PBVT](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pbvt) and is used during the [Localization Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-1-localization-stage).

The In-Memory Map:

- Converts the map into a grid of discrete waypoints.

- Includes waypoints in a specific data structure with more information to connect waypoints and identify roads, junctions, etc.

- Identifies these structures with an ID used to locate vehicles in nearby areas quickly.

Related .cpp files: `InMemoryMap.cpp` and `SimpleWaypoint.cpp`.

### PBVT

PBVT stands for **Path Buffer and Vehicle Tracking**. The PBVT is a data structure that contains the **expected path** for every vehicle and allows easy access to data during the [control loop](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#control-loop).

The PBVT:

- Contains a map of deque objects with one entry per vehicle.

- Contains a set of waypoints for each vehicle describing its current location and near-future path.

- Contains the [In-Memory Map](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#in-memory-map) used by the [Localization Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-1-localization-stage) to relate every vehicle to the nearest waypoint and possible overlapping paths.

### PID controller

The PID controller is a helper module that performs calculations during the [Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage).

The PID controller:

- Estimates the throttle, brake, and steering input needed to reach a target value using the information gathered by the [Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage).

- Makes adjustments depending on the specific parameterization of the controller. Parameters can be modified if desired. Read more about [PID controllers](https://en.wikipedia.org/wiki/PID_controller) to learn how to make modifications.

Related .cpp files: `PIDController.cpp`.

### Command Array

The Command Array represents the **last step** in the TM logic cycle. It receives commands for all the registered vehicles and applies them.

The Command Array:

- Receives a series of [carla.VehicleControl](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.VehicleControl)'s from the [Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage).

- Batches all commands to be applied during the same frame.

- Sends the batch to the CARLA server calling either `apply_batch()` or `apply_batch_synch()` in [carla.Client](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.Client) depending on whether the simulation is running in asynchronous or synchronous mode, respectively.

Related .cpp files: `TrafficManagerLocal.cpp`.

### Stages of the Control Loop

#### Stage 1- Localization Stage

The Localization Stage defines a near-future path for vehicles controlled by the TM.

The Localization Stage:

- Obtains the position and velocity of all vehicles from the [simulation state](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#simulation-state).

- Uses the [In-Memory Map](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#in-memory-map) to relate every vehicle with a list of waypoints that describes its current location and near-future path according to its trajectory. The faster the vehicle goes, the longer the list will be.

- Updates the path according to planning decisions such as lane changes, speed limit, distance to leading vehicle parameterization, etc.

- Stores the path for all vehicles in the [PBVT](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pbvt) module.

Compares paths with each other to estimate possible collision situations. Results are passed to the Collision Stage.

Related .cpp files: `LocalizationStage.cpp` and `LocalizationUtils.cpp`.

#### Stage 2- Collision Stage

The Collision Stage triggers collision hazards.

The Collision Stage:

- Receives from the [Localization Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-1-localization-stage) a list of vehicle pairs whose paths could potentially overlap.

- Extends bounding boxes along the path ahead (geodesic boundaries) for each vehicle pair to check if they actually overlap and determine whether the risk of collision is real.

- Sends hazards for all possible collisions to the [Motion Planner Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-4-motion-planner-stage) to modify the path accordingly.

Related .cpp files: `CollisionStage.cpp`.

#### Stage 3- Traffic Light Stage

The Traffic Light stage triggers hazards due to traffic regulators such as traffic lights, stop signs, and priority at junctions.

The Traffic Light stage:

- Sets a traffic hazard if a vehicle is under the influence of a yellow or red traffic light or a stop sign.

- Extends a bounding box along a vehicle's path if it is in an unsignaled junction. Vehicles with overlapping paths follow a "First-In-First-Out" order to move. Wait times are set to a fixed value.

Related .cpp files: `TrafficLightStage.cpp`.

#### Stage 4- Motion Planner Stage

The Motion Planner Stage **generates the CARLA commands** to be applied to vehicles.

The Motion Planner Stage:

- Gathers a vehicle's position and velocity ([simulation state](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#simulation-state)), path ([PBVT](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pbvt)), and hazards ([Collision Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-2-collision-stage) and [Traffic Light Stage](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#stage-3-traffic-light-stage)).

- Makes high-level decisions about how a vehicle should move, for example, computing the brake needed to prevent a collision hazard. A [PID controller](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#pid-controller) is used to estimate behaviors according to target values.

- Translates the desired movement to a [carla.VehicleControl](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.VehicleControl) for application to the vehicle.

- Sends the resulting CARLA commands to the [Command Array](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/#command-array).

Related .cpp files: MotionPlannerStage.cpp.

#### Stage 5- Vehicle Lights Stage

The Vehicle Lights Stage activates the lights based on the condition of the vehicle and the surrounding environment.

The Vehicle Lights Stage:

- Retrieves the planned waypoints for the vehicle, information about vehicle lights (eg. light state and the planned command to be applied) and the weather conditions.

- Determines the new state of the vehicle lights:

  - Turns on the blinkers if the vehicle is planning to turn left/right at the next junction.
  - Turns on the stop lights if the applied command is asking the vehicle to brake.
  Turns on the low beams and the position lights from sunset to dawn, or under heavy rain.
  - Turns on the fog lights under heavy fog conditions.

- Update the vehicle lights state if it has changed.

Related .cpp files: `VehicleLightStage.cpp`.

## Using the Traffic Manager

### Vehicle behavior considerations




