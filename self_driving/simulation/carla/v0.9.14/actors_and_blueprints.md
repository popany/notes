# [Actors and blueprints](https://carla.readthedocs.io/en/0.9.14/core_actors/)

- [Actors and blueprints](#actors-and-blueprints)
  - [Blueprints](#blueprints)
  - [Managing the blueprint library](#managing-the-blueprint-library)
  - [Actor life cycle](#actor-life-cycle)
    - [Spawning](#spawning)
    - [Destruction](#destruction)
  - [Types of actors](#types-of-actors)
    - [Sensors](#sensors)
    - [Spectator](#spectator)
    - [Traffic signs and traffic lights](#traffic-signs-and-traffic-lights)
    - [Vehicles](#vehicles)
    - [Walkers](#walkers)

Actors in CARLA are the elements that perform actions within the simulation, and they can affect other actors. Actors in CARLA includes vehicles and walkers and also sensors, traffic signs, traffic lights and the spectator. It is crucial to have full understanding on how to operate on them.

## Blueprints

These layouts allow the user to smoothly incorporate new actors into the simulation. They are already-made models with animations and a series of attributes. Some of these are modifiable and others are not. These attributes include, among others, vehicle color, amount of channels in a lidar sensor, a walker's speed, and much more.

Available blueprints are listed in the [blueprint library](https://carla.readthedocs.io/en/0.9.14/bp_library/), along with their attributes. Vehicle and walker blueprints have a **generation attribute** that indicates if they are a new (gen 2) or old (gen 1) asset.

## Managing the blueprint library

The [`carla.BlueprintLibrary`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.BlueprintLibrary) class contains a list of [`carla.ActorBlueprint`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.ActorBlueprint) elements. It is the world object who can provide access to it.

    blueprint_library = world.get_blueprint_library()

Blueprints have an ID to identify them and the actors spawned with it. The library can be read to find a certain ID, choose a blueprint at random, or filter results using a [wildcard pattern](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm).

    # Find a specific blueprint.
    collision_sensor_bp = blueprint_library.find('sensor.other.collision')
    # Choose a vehicle blueprint at random.
    vehicle_bp = random.choice(blueprint_library.filter('vehicle.*.*'))

Besides that, each [`carla.ActorBlueprint`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.ActorBlueprint) has a series of [`carla.ActorAttribute`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.ActorAttribute) that can be get and set.

    is_bike = [vehicle.get_attribute('number_of_wheels') == 2]
    if(is_bike)
        vehicle.set_attribute('color', '255,0,0')

Some of the attributes cannot be modified. Check it out in the [blueprint library](https://carla.readthedocs.io/en/0.9.14/bp_library/).

Attributes have an [`carla.ActorAttributeType`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.ActorAttributeType) variable. It states its type from a list of enums. Also, modifiable attributes come with a list of recommended values.

    for attr in blueprint:
        if attr.is_modifiable:
            blueprint.set_attribute(attr.id, random.choice(attr.recommended_values))

Users can create their own vehicles. Check the Tutorials (assets) to learn on that. Contributors can [add their new content to CARLA](https://carla.readthedocs.io/en/0.9.14/tuto_D_contribute_assets/).

## Actor life cycle

This section mentions different methods regarding actors. The Python API provides for [commands](https://carla.readthedocs.io/en/0.9.14/python_api/#command.SpawnActor) to apply batches of the most common ones, in just one frame.

### Spawning

The **world object** is responsible of **spawning** actors and **keeping track** of these. Spawning only requires a blueprint, and a [`carla.Transform`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.Transform) stating a location and rotation for the actor.

The world has two different methods to spawn actors.

- [`spawn_actor()`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.World.spawn_actor) raises an exception if the spawning fails.
- [`try_spawn_actor()`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.World.try_spawn_actor) returns `None` if the spawning fails.

    transform = Transform(Location(x=230, y=195, z=40), Rotation(yaw=180))
    actor = world.spawn_actor(blueprint, transform)

CARLA uses the [Unreal Engine coordinates system](https://carla.readthedocs.io/en/latest/python_api/#carlarotation). Remember that `carla.Rotation` constructor is defined as `(pitch, yaw, roll)`, that differs from Unreal Engine Editor `(roll, pitch, yaw)`.

The actor will not be spawned in case of collision at the specified location. No matter if this happens with a static object or another actor. It is possible to try avoiding these undesired spawning collisions.

- `map.get_spawn_points()` **for vehicles**. Returns a list of recommended spawning points.

      spawn_points = world.get_map().get_spawn_points()

- `world.get_random_location()` **for walkers**. Returns a random point on a sidewalk. This same method is used to set a goal location for walkers.

      spawn_point = carla.Transform()
      spawn_point.location = world.get_random_location_from_navigation()

An actor can be attached to another one when spawned. Actors follow the parent they are attached to. This is specially useful for sensors. The attachment can be rigid (proper to retrieve precise data) or with an eased movement according to its parent. It is defined by the helper class [`carla.AttachmentType`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.AttachmentType).

The next example attaches a camera rigidly to a vehicle, so their relative position remains fixed.

    camera = world.spawn_actor(camera_bp, relative_transform, attach_to=my_vehicle, carla.AttachmentType.Rigid)

When spawning attached actors, **the transform provided must be relative to the parent actor**.

Once spawned, the world object adds the actors to a list. This can be easily searched or iterated on.

    actor_list = world.get_actors()
    # Find an actor by id.
    actor = actor_list.find(id)
    # Print the location of all the speed limit signs in the world.
    for speed_sign in actor_list.filter('traffic.speed_limit.*'):
        print(speed_sign.get_location())

[`carla.Actor`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.Actor) mostly consists of `get()` and `set()` methods to manage the actors around the map.

    print(actor.get_acceleration())
    print(actor.get_velocity())

    location = actor.get_location()
    location.z += 10.0
    actor.set_location(location)

The actor's physics can be disabled to freeze it in place.

    actor.set_simulate_physics(False)

Besides that, actors also have tags provided by their blueprints. These are mostly useful for semantic segmentation sensors.

Most of the methods send requests to the simulator asynchronously. The simulator has a limited amount of time each update to parse them. Flooding the simulator with `set()` methods will accumulate a significant lag.

### Destruction

Actors are not destroyed when a Python script finishes. They have to explicitly destroy themselves.

    destroyed_sucessfully = actor.destroy() # Returns True if successful

Destroying an actor **blocks** the simulator until the process finishes.

## Types of actors

### Sensors

Sensors are actors that produce a stream of data. They have their own section, [4th. Sensors and data](https://carla.readthedocs.io/en/0.9.14/core_sensors/). For now, let's just take a look at a common sensor spawning cycle.

This example spawns a camera sensor, attaches it to a vehicle, and tells the camera to save the images generated to disk.

    camera_bp = blueprint_library.find('sensor.camera.rgb')
    camera = world.spawn_actor(camera_bp, relative_transform, attach_to=my_vehicle)
    camera.listen(lambda image: image.save_to_disk('output/%06d.png' % image.frame))

- Sensors have blueprints too. Setting attributes is crucial.

- Most of the sensors will be attached to a vehicle to gather information on its surroundings.

- Sensors listen to data. When data is received, they call a function described with a Lambda expression (6.13 in the link provided).

### Spectator

Placed by Unreal Engine to provide an in-game point of view. It can be used to move the view of the simulator window. The following example would move the spectator actor, to point the view towards a desired vehicle.

    spectator = world.get_spectator()
    transform = vehicle.get_transform()
    spectator.set_transform(carla.Transform(transform.location + carla.Location(z=50),
    carla.Rotation(pitch=-90)))

### Traffic signs and traffic lights

...

### Vehicles

[`carla.Vehicle`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.Vehicle) is a special type of actor. It incorporates special internal components that simulate the physics of wheeled vehicles. This is achieved by applying four types of different controls:

- [`carla.VehicleControl`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.VehicleControl) provides input for driving commands such as throttle, steering, brake, etc.

      vehicle.apply_control(carla.VehicleControl(throttle=1.0, steer=-1.0))

- [`carla.VehiclePhysicsControl`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.VehiclePhysicsControl) defines physical attributes of the vehicle and contains two more controllers:

  - [`carla.GearPhysicsControl`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.GearPhysicsControl) which controls the gears.

  - [`carla.WheelPhysicsControl`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.WheelPhysicsControl) which provides specific control over each wheel.

        vehicle.apply_physics_control(carla.VehiclePhysicsControl(max_rpm = 5000.0, center_of_mass = carla.Vector3D(0.0, 0.0, 0.0), torque_curve=[[0,400],[5000,400]]))

Vehicles have a [`carla.BoundingBox`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.BoundingBox) encapsulating them. This bounding box allows physics to be applied to the vehicle and enables collisions to be detected.

    box = vehicle.bounding_box
    print(box.location)         # Location relative to the vehicle.
    print(box.extent)           # XYZ half-box extents in meters.

The physics of vehicle wheels can be improved by enabling the [sweep wheel collision parameter](https://carla.readthedocs.io/en/latest/python_api/#carla.VehiclePhysicsControl.use_sweep_wheel_collision). The default wheel physics uses single ray casting from the axis to the floor for each wheel but when sweep wheel collision is enabled, the full volume of the wheel is checked against collisions. It can be enabled as such:

    physics_control = vehicle.get_physics_control()
    physics_control.use_sweep_wheel_collision = True
    vehicle.apply_physics_control(physics_control)

Vehicles include other functionalities unique to them:

- Autopilot mode will subscribe a vehicle to the [Traffic Manager](https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/) to simulate real urban conditions. This module is hard-coded, not based on machine learning.

      vehicle.set_autopilot(True)

- Vehicle lights have to be turned on and off by the user. Each vehicle has a set of lights listed in [`carla.VehicleLightState`](https://carla.readthedocs.io/en/0.9.14/python_api/#carla.VehicleLightState). Not all vehicles have lights integrated. At the time of writing, vehicles with integrated lights are as follows:

- Bikes: All bikes have a front and back position light.

- Motorcycles: Yamaha and Harley Davidson models.

- Cars: Audi TT, Chevrolet Impala, both Dodge police cars, Dodge Charger, Audi e-tron, Lincoln 2017 and 2020, Mustang, Tesla Model 3, Tesla Cybertruck, Volkswagen T2 and the Mercedes C-Class.

### Walkers

...
