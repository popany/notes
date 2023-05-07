# [Core concepts](https://carla.readthedocs.io/en/0.9.14/core_concepts/)

- [Core concepts](#core-concepts)
  - [First steps](#first-steps)
    - [1st- World and client](#1st--world-and-client)
    - [2nd- Actors and blueprints](#2nd--actors-and-blueprints)
    - [3rd- Maps and navigation](#3rd--maps-and-navigation)
    - [4th- Sensors and data](#4th--sensors-and-data)
  - [Advanced steps](#advanced-steps)

## First steps

### 1st- World and client

The client is the module the user runs to ask for information or changes in the simulation. A client runs with an IP and a specific port. It communicates with the server via terminal. There can be many clients running at the same time. Advanced multiclient managing requires thorough understanding of CARLA and [synchrony](https://carla.readthedocs.io/en/0.9.14/adv_synchrony_timestep/).

The world is an object representing the simulation. It acts as an abstract layer containing the main methods to spawn actors, change the weather, get the current state of the world, etc. There is only one world per simulation. It will be destroyed and substituted for a new one when the map is changed.

### 2nd- Actors and blueprints

An actor is anything that plays a role in the simulation.

- Vehicles.
- Walkers.
- Sensors.
- The spectator.
- Traffic signs and traffic lights.

Blueprints are already-made actor layouts necessary to spawn an actor. Basically, models with animations and a set of attributes. Some of these attributes can be customized by the user, others don't. There is a [Blueprint library](https://carla.readthedocs.io/en/0.9.14/bp_library/) containing all the blueprints available as well as information on them.

### 3rd- Maps and navigation

The map is the object representing the simulated world, the town mostly. There are eight maps available. All of them use OpenDRIVE 1.4 standard to describe the roads.

Roads, lanes and junctions are managed by the [Python API](https://carla.readthedocs.io/en/0.9.14/python_api/) to be accessed from the client. These are used along with the **waypoint** class to provide vehicles with a navigation path.

Traffic signs and traffic lights are accessible as [carla.Landmark](https://carla.readthedocs.io/en/0.9.14/core_concepts/#python_api.md#carla.landmark) objects that contain information about their OpenDRIVE definition. Additionally, the simulator automatically generates stops, yields and traffic light objects when running using the information on the OpenDRIVE file. These have bounding boxes placed on the road. Vehicles become aware of them once inside their bounding box.

### 4th- Sensors and data

Sensors **wait for some event** to happen, and then **gather data** from the simulation. They call for a function defining how to manage the data. Depending on which, sensors retrieve different types of sensor data.

A sensor is an actor attached to a parent vehicle. It follows the vehicle around, gathering information of the surroundings. The sensors available are defined by their blueprints in the [Blueprint library](https://carla.readthedocs.io/en/0.9.14/bp_library/).

- Cameras (RGB, depth and semantic segmentation).
- Collision detector.
- Gnss sensor.
- IMU sensor.
- Lidar raycast.
- Lane invasion detector.
- Obstacle detector.
- Radar.
- RSS.

## Advanced steps

...
