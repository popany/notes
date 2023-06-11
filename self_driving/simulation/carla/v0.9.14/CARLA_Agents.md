# [CARLA Agents](https://carla.readthedocs.io/en/0.9.14/adv_agents/)

- [CARLA Agents](#carla-agents)
  - [Overview of agent scripts](#overview-of-agent-scripts)
  - [Planning and control](#planning-and-control)
  - [Agent behaviors](#agent-behaviors)
  - [Implement an agent](#implement-an-agent)
  - [Behavior types](#behavior-types)
  - [Create your own behavior type](#create-your-own-behavior-type)
  - [Creating an agent](#creating-an-agent)

CARLA Agent scripts allow a vehicle to either follow a random, endless route or take the shortest route to a given destination. Agents obey traffic lights and react to other obstacles in the road. There are three agent types available. Parameters such as target speed, braking distance, tailgating behavior, and more can be modified. Actor classes can be modified or used as a base class to create custom agents according to the user's needs.

## Overview of agent scripts

The main scripts involved in the CARLA Agents are found in `PythonAPI/carla/agents/navigation`. They fall into two categories; **planning and control** and **agent behaviors**.

## Planning and control

- `controller.py`: Combines longitudinal and lateral PID controllers into a single class, `VehiclePIDController`, used for low-level control of vehicles **from the client side** of CARLA.

- `global_route_planner.py`: Gets detailed topology **from the CARLA server** to build a graph representation of the world map, **providing waypoint and road option** information for the Local Planner.

- `local_planner.py`: Follows waypoints based on control inputs from the `VehiclePIDController`. Waypoints can either be provided by the Global Route Planner or be calculated dynamically, choosing random paths at junctions, similar to the Traffic Manager.

## Agent behaviors

- `basic_agent.py`: Contains an agent base class that implements a **Basic Agent** that roams around the map or reaches a target destination in the shortest distance possible, avoiding other vehicles, responding to traffic lights but ignoring stop signs.

- `behavior_agent.py`: Contains a class that implements a more complex **Behavior Agent** that can reach a target destination in the shortest distance possible, following traffic lights, signs, and speed limits while tailgating other vehicles. There are three predefined types that condition how the agent behaves.

- `behavior_types.py`: Contains the parameters for the behavior types that condition the **Behavior Agent**; Cautious, Normal, and Aggressive.

## Implement an agent

This section will explain how to use the example CARLA Agent classes in your own scripts. At the end of the section, you will find out how to run an example script that shows the different agents in action.

1. Import the agent class you want to use:

       # To import a basic agent
       from agents.navigation.basic_agent import BasicAgent
       
       # To import a behavior agent
       from agents.navigation.behavior_agent import BehaviorAgent

2. Any vehicle can be turned into an agent. [Spawn a vehicle](https://carla.readthedocs.io/en/0.9.14/core_actors/#spawning) and pass it as an argument to the agent class to instantiate it:

       # To start a basic agent
       agent = BasicAgent(vehicle)
       
       # To start a behavior agent with an aggressive profile
       agent = BehaviorAgent(vehicle, behavior='aggressive')

   Read more about behavior types and how to configure your own in the section behavior types.

3. You can set a destination for the agent to travel to. If you don't set a destination for the agent, it will roam endlessly around the map. To set the destination, provide the agent with a [location](https://carla.readthedocs.io/en/0.9.14/python_api/#carlalocation):

       destination = random.choice(spawn_points).location
       agent.set_destination(destination)

4. Vehicle controls and behaviors are **applied during a navigation step**. During each step, the **Basic Agent** will apply a vehicle control and react to any vehicles or traffic lights by performing an emergency stop. The **Behavior Agent** will react to traffic lights, avoid pedestrians, follow cars and navigate intersections according to the behavior type you applied:

       while True:
           vehicle.apply_control(agent.run_step())

5. You can check if the agent has finished its trajectory and perform an action when that happens. The following snippet will end the simulation once your vehicle has reached its destination:

       while True:
           if agent.done():
               print("The target has been reached, stopping the simulation")
               break
       
           vehicle.apply_control(agent.run_step())

6. Instead of finishing the simulation when an agent has reached its target destination, a new, random route can be generated for the agent to follow:

       while True:
           if agent.done():
               agent.set_destination(random.choice(spawn_points).location)
               print("The target has been reached, searching for another target")
       
           vehicle.apply_control(agent.run_step())

The **Basic Agent** provides a few methods to manipulate agent behavior or program routes to follow:

- `set_target_speed(speed)`: Set the target speed in km/h

- `follow_speed_limits(value=True)`: Sets the agent to follow speed limits.

- `set_destination(end_location, start_location=None)`: The agent will travel from a specific start location to an end location via the shortest route possible. If no start location is provided, it will use the current agent location.

- `set_global_plan(plan, stop_waypoint_creation=True, clean_queue=True)`: Adds a specific plan for the agent to follow. The plan argument should consist of a list of `[carla.Waypoint, RoadOption]` that will be the path the agent needs to take. `stop_waypoint_creation` will prevent waypoints from being automatically created once the path has run its course. `clean_queue` will reset the agent's current plan.

- `trace_route(start_waypoint, end_waypoint)`: Gets the shortest distance between two waypoints from the **Global Route Planner** and returns the path as a list of `[carla.Waypoint, RoadOption]` for the agent to follow.

- `ignore_traffic_lights(active=True)`: Set the agent to ignore or obey traffic lights.

- `ignore_stop_signs(active=True)`: Set the agent to ignore or obey stop signs.

- `ignore_vehicles(active=True)`: Set the agent to ignore or react to other vehicles.

The `automatic_control.py` script, found in `PythonAPI/examples`, is an example of the Basic and Behavior Agents in action. To try the script, navigate to the example directory and run the following command:

    # To run with a basic agent
    python3 automatic_control.py --agent=Basic

    # To run with a behavior agent
    python3 automatic_control.py --agent=Behavior --behavior=aggressive

## Behavior types

Behavior types for the behavior agent are defined in `behavior_types.py`. The three pre-configured profiles are 'cautious', 'normal', and 'aggressive'. You can use the set profiles, modify them or create your own. The following variables can be adjusted:

- `max_speed`: The maximum speed in km/h your vehicle will be able to reach.

- `speed_lim_dist`: Value in km/h that defines how far your vehicle's target speed will be from the current speed limit (e.g., if the speed limit is 30km/h and `speed_lim_dist` is 10km/h, then the target speed will be 20km/h)

- `speed_decrease`: How quickly in km/h your vehicle will slow down when approaching a slower vehicle ahead.

- `safety_time`: Time-to-collision; an approximation of the time it will take for your vehicle to collide with one in front if it brakes suddenly.

- `min_proximity_threshold`: The minimum distance in meters from another vehicle or pedestrian before your vehicle performs a maneuver such as avoidance, or tailgating.

- `braking_distance`: The distance from a pedestrian or vehicle at which your vehicle will perform an emergency stop.

- `tailgate_counter`: A counter to avoid tailgating too quickly after the last tailgate.

## Create your own behavior type

To create your own behavior type:

1. Create the class for your behavior type in `behavior_types.py`:

       class ProfileName(object):
           # complete value definitions

2. Define and instantiate your behavior type in the `behavior_agent.py` script:

       # Parameters for agent behavior
       if behavior == 'cautious':
           self._behavior = Cautious()
       
       elif behavior == 'normal':
           self._behavior = Normal()
       
       elif behavior == 'aggressive':
           self._behavior = Aggressive()
       
       elif behavior == '<type_name>':
           self._behavior = <TypeName>()

## Creating an agent

The CARLA Agents are just examples of the kind of agents users can run. Users can build upon the **Basic Agent** to create their own agents. The possibilities are endless. There are only two elements that are necessary for every agent, the **initialization** and the **run step**.

Find an example of a minimal layout of a custom agent below:

    import carla
    
    from agents.navigation.basic_agent import BasicAgent
    
    class CustomAgent(BasicAgent):
        def __init__(self, vehicle, target_speed=20, debug=False):
            """
            :param vehicle: actor to apply to local planner logic onto
            :param target_speed: speed (in Km/h) at which the vehicle will move
            """
            super().__init__(target_speed, debug)
    
        def run_step(self, debug=False):
            """
            Execute one step of navigation.
            :return: carla.VehicleControl
            """
            # Actions to take during each simulation step
            control = carla.VehicleControl()
            return control

Check out the `basic_agent.py` and `behavior_agent.py` scripts to explore their structure and functions for more ideas on how to create your own.
