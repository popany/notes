# [First steps with CARLA](https://carla.readthedocs.io/en/0.9.14/tuto_first_steps/)

- [First steps with CARLA](#first-steps-with-carla)
  - [Launching CARLA and connecting the client](#launching-carla-and-connecting-the-client)
  - [Loading a map](#loading-a-map)
  - [Spectator navigation](#spectator-navigation)
  - [Adding NPCs](#adding-npcs)
  - [Add sensors](#add-sensors)
  - [Animate vehicles with traffic manager](#animate-vehicles-with-traffic-manager)

The CARLA simulator is a comprehensive solution for producing synthetic training data for applications in autonomous driving (AD) and also other robotics applications. CARLA simulates a highly realistic environment emulating real world towns, cities and highways and the vehicles and other objects that occupy these driving spaces.

The CARLA simulator is further useful as an evaluation and testing environment. You can deploy the AD agents you have trained within the simulation to test and evaluate their performance and safety, all within the security of a simulated environment, with no risk to hardware or other road users.

In this tutorial, we will cover a standard workflow in CARLA, from launching the server and connecting the client, through to adding vehicles, sensors and generating training data to use for machine learning. This tutorial is meant to be light on details and go as efficiently as possible through the key steps in using CARLA to produce machine learning training data. For further details on each part of the workflow, such as the multitude of vehicles available in the blueprint library or the alternative types of sensors available, please consult the links in the text or browse the left menu.

## Launching CARLA and connecting the client

...

## Loading a map

...

## Spectator navigation

...

## Adding NPCs

...

## Add sensors

...

## Animate vehicles with traffic manager

Now we've added our traffic and ego vehicle to the simulation and started recording camera data, we now need to set the vehicles in motion using the [Traffic manager](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/). The Traffic manager is a component of CARLA that **controls vehicles to autonomously move around the roads** of the map within the simulation, **following the road conventions and behaving like real road users**.

We can find all the vehicles in the simulation using the `world.get_actors()` method, filtering for all the vehicles. We can then use the `set_autopilot()` method to hand over control of the vehicle to the Traffic Manager.

    for vehicle in world.get_actors().filter('*vehicle*'):
        vehicle.set_autopilot(True)

Now your simulation is running, with numerous vehicles driving around the map and a camera recording data from one of those vehicles. This data can then be used to feed a machine learning algorithm for training an autonomous driving agent. The Traffic manager has many functions for customising traffic behaviour, learn more [here](https://carla.readthedocs.io/en/0.9.14/tuto_G_traffic_manager/).









