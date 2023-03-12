# [ASAM OpenSCENARIO: User Guide](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4908&token=ae9d9b44ab9257e817072a653b5d5e98ee0babf8)

- [ASAM OpenSCENARIO: User Guide](#asam-openscenario-user-guide)
  - [Introduction](#introduction)
    - [Overview](#overview)
      - [What is a scenario?](#what-is-a-scenario)
      - [What is ASAM OpenSCENARIO?](#what-is-asam-openscenario)
    - [Conventions and notations](#conventions-and-notations)
      - [Normative and non-normative statements](#normative-and-non-normative-statements)
      - [Naming conventions](#naming-conventions)
      - [Units](#units)
      - [Data types](#data-types)
      - [Modal verbs](#modal-verbs)
      - [Typographic conventions](#typographic-conventions)
    - [Deliverables](#deliverables)
    - [Revision history](#revision-history)
    - [Changelog](#changelog)
    - [Complementary standards and formats](#complementary-standards-and-formats)
  - [1. Scope](#1-scope)
  - [2. Normative References](#2-normative-references)
  - [3. Terms and definitions](#3-terms-and-definitions)
    - [Ego vehicle](#ego-vehicle)
    - [Parameterization](#parameterization)
    - [World](#world)
  - [4. Abbreviations](#4-abbreviations)
  - [5. Backward compatibility](#5-backward-compatibility)
  - [6. General concepts](#6-general-concepts)
    - [6.1. Architecture](#61-architecture)
      - [6.1.1. Basic architecture components](#611-basic-architecture-components)
      - [6.1.2. ASAM OpenSCENARIO elements](#612-asam-openscenario-elements)
        - [Elements of the OSC Director](#elements-of-the-osc-director)
        - [Elements in the Simulator Core](#elements-in-the-simulator-core)
        - [Element states](#element-states)
        - [Static elements](#static-elements)
      - [6.1.3. Executing a scenario](#613-executing-a-scenario)
      - [6.1.4. Actions and conditions](#614-actions-and-conditions)
      - [6.1.5. Abstract ASAM OpenSCENARIO architecture](#615-abstract-asam-openscenario-architecture)
    - [6.2. Road networks and environment models](#62-road-networks-and-environment-models)
    - [6.3. Coordinate systems](#63-coordinate-systems)
      - [6.3.1. World coordinate system (Xw, Yw, Zw)](#631-world-coordinate-system-xw-yw-zw)
      - [6.3.2. Road coordinate system (s/t)](#632-road-coordinate-system-st)
      - [6.3.3. Lane coordinate System (s/t)](#633-lane-coordinate-system-st)
      - [6.3.4. Vehicle coordinate system (Xv, Yv, Zv)](#634-vehicle-coordinate-system-xv-yv-zv)
      - [6.3.5. Pedestrian / MiscObject coordinate system (Xp/m , Yp/m , Zp/m)](#635-pedestrian--miscobject-coordinate-system-xpm--ypm--zpm)
      - [6.3.6. Trajectory coordinate system (s/t)](#636-trajectory-coordinate-system-st)
      - [6.3.7. Geographic coordinate system (latitude, longitude, altitude)](#637-geographic-coordinate-system-latitude-longitude-altitude)
      - [6.3.8. Positioning](#638-positioning)
    - [6.4. Distances](#64-distances)
      - [6.4.1. Visualization](#641-visualization)
      - [6.4.2. Referring to distances in ASAM OpenSCENARIO](#642-referring-to-distances-in-asam-openscenario)
      - [6.4.3. Euclidean distance](#643-euclidean-distance)
      - [6.4.4. Distances in an entity coordinate system](#644-distances-in-an-entity-coordinate-system)
      - [6.4.5. Distances in road coordinates](#645-distances-in-road-coordinates)
      - [6.4.6. Lane distance and trajectory distance](#646-lane-distance-and-trajectory-distance)
      - [6.4.7. Involving an entity in a distance calculation](#647-involving-an-entity-in-a-distance-calculation)
        - [freeSpace = false](#freespace--false)
        - [freeSpace = true](#freespace--true)
      - [6.4.8. Guideline for positions on different roads](#648-guideline-for-positions-on-different-roads)
        - [Longitudinal distance](#longitudinal-distance)
          - [Road coordinate system](#road-coordinate-system)
          - [Lane coordinate system](#lane-coordinate-system)
          - [Trajectory coordinate system](#trajectory-coordinate-system)
        - [Lateral distance](#lateral-distance)
          - [Road coordinate system](#road-coordinate-system-1)
          - [Lane coordinate system](#lane-coordinate-system-1)
          - [Trajectory coordinate system](#trajectory-coordinate-system-1)
        - [Helping route](#helping-route)
    - [6.5. Speed](#65-speed)
    - [6.6. Controllers](#66-controllers)
      - [6.6.1. Controller types](#661-controller-types)
      - [6.6.2. Controlling a scenario object](#662-controlling-a-scenario-object)
      - [6.6.3. Assigning a user-defined controller](#663-assigning-a-user-defined-controller)
      - [6.6.4. Activating a user-defined controller](#664-activating-a-user-defined-controller)
      - [6.6.5. Assigning the default controller](#665-assigning-the-default-controller)
      - [6.6.6. Activating the default controller](#666-activating-the-default-controller)
    - [6.7. Appearance](#67-appearance)
    - [6.8. Routes](#68-routes)
    - [6.9. Trajectories](#69-trajectories)
        - [6.9.1. Entity is not at the start of trajectory, timeReference is not set](#691-entity-is-not-at-the-start-of-trajectory-timereference-is-not-set)
        - [6.9.2. Entity is not at the start of trajectory, timeReference is set (in the future)](#692-entity-is-not-at-the-start-of-trajectory-timereference-is-set-in-the-future)
        - [6.9.3. Entity is not at the start of trajectory, timeReference is set (in the past)](#693-entity-is-not-at-the-start-of-trajectory-timereference-is-set-in-the-past)
        - [6.9.4. Entity is at an ambiguous point near the trajectory](#694-entity-is-at-an-ambiguous-point-near-the-trajectory)
        - [6.9.5. Trajectory-relative positions](#695-trajectory-relative-positions)
    - [6.10. Traffic simulation](#610-traffic-simulation)
    - [6.11. Traffic signals](#611-traffic-signals)
    - [6.12. Variables](#612-variables)
    - [6.13. Properties](#613-properties)
  - [7. Components of a scenario](#7-components-of-a-scenario)
    - [7.1. Overview of a scenario](#71-overview-of-a-scenario)
    - [7.2. Storyboard and entities](#72-storyboard-and-entities)
      - [7.2.1. Storyboard](#721-storyboard)
      - [7.2.2. Entities](#722-entities)
        - [Motion control for entities](#motion-control-for-entities)
        - [Entity selections](#entity-selections)
        - [Spawned objects](#spawned-objects)
        - [Entity class hierarchy](#entity-class-hierarchy)
        - [Generalization of entities](#generalization-of-entities)
        - [3D models for entities](#3d-models-for-entities)
    - [7.3. ManeuverGroups, Events and Maneuvers](#73-maneuvergroups-events-and-maneuvers)
      - [7.3.1. ManeuverGroups and Actors](#731-maneuvergroups-and-actors)
      - [7.3.2. Events](#732-events)
      - [7.3.3. Maneuver](#733-maneuver)
    - [7.4. Actions](#74-actions)
      - [7.4.1. Private action](#741-private-action)
      - [7.4.2. Global action](#742-global-action)
      - [7.4.3. User-defined action](#743-user-defined-action)
    - [7.5. Actions at runtime](#75-actions-at-runtime)
    - [7.6. Conditions and triggers](#76-conditions-and-triggers)
      - [7.6.1. Triggers and condition groups](#761-triggers-and-condition-groups)
        - [Start trigger](#start-trigger)
        - [Stop trigger](#stop-trigger)
      - [7.6.2. Condition edges](#762-condition-edges)
      - [7.6.3. Condition delay](#763-condition-delay)
      - [7.6.4. Corner cases of edges and delays](#764-corner-cases-of-edges-and-delays)
      - [7.6.5. Condition types](#765-condition-types)
        - [ByEntityConditions](#byentityconditions)
        - [ByValueConditions](#byvalueconditions)
  - [8. Scenario at runtime](#8-scenario-at-runtime)
  - [9. Reuse mechanisms](#9-reuse-mechanisms)
  - [10. Tutorial: How to create a scenario](#10-tutorial-how-to-create-a-scenario)
    - [10.1. Example description of a scenario](#101-example-description-of-a-scenario)
    - [10.2. Entities](#102-entities)
    - [10.3. Init section](#103-init-section)
    - [10.4. Stories](#104-stories)
    - [10.5. Acts](#105-acts)
    - [10.6. ManeuverGroups](#106-maneuvergroups)
    - [10.7. Maneuvers](#107-maneuvers)
    - [10.8. Events and actions](#108-events-and-actions)
    - [10.9. Sequential execution](#109-sequential-execution)
    - [10.10. Traffic signal](#1010-traffic-signal)
  - [11. Examples](#11-examples)

## Introduction

### Overview

The primary use of ASAM OpenSCENARIO is the description of complex maneuvers that involve multiple vehicles.

The standard may be used in conjunction with ASAM OpenDRIVE [1] and ASAM OpenCRG [2], which describe static content in driving simulation.

#### What is a scenario?

A scenario is a description of how the view of the world changes with time, usually from a specific perspective.

In a simulation context, a complete scenario is comprised of the following parts:

- Static environment description, including:

  - Logical road network

  - Optionally physical and geometric road and environment descriptions

- Dynamic content description, including:

  - Overall description and coordination of behavior of dynamic entities

  - Optional behavior models of dynamic entities

#### What is ASAM OpenSCENARIO?

ASAM OpenSCENARIO defines a **data model** and a **derived file format** for the description of scenarios used in driving and traffic simulators, as well as in automotive virtual development, testing, and validation.

The standard provides the **description methodology** for scenarios by defining hierarchical elements, from which scenarios, their attributes, and relations are constructed. This methodology comprises:

- Storyboarding, that is usage of a storyboard and stories. Each story consists of one or more acts and maneuvers.

- An event is triggered by a trigger, when a condition is evaluated to true. Events cause the execution of actions.

- References to logical road network descriptions.

- Instantiation of entities, such as vehicles, or pedestrians, acting on and off the road.

- Catalogs and parameter declarations provide mechanisms to re-use several aspects of a scenario.

Other content, such as the description of the ego vehicle, entity appearance, pedestrians, traffic and environment conditions, is included in the standard as well.

Scenario descriptions in ASAM OpenSCENARIO are organized in a hierarchical structure and serialized in an **XML file format** with the file extension .xosc.

ASAM OpenSCENARIO defines the **dynamic content** of the (simulated) world, for example, the behavior of traffic participants. Static components, such as the road network, are **not** part of ASAM OpenSCENARIO but can be referenced by the format.

ASAM OpenSCENARIO does **not** specify the behavior models themselves or their handling by a simulation engine.

Furthermore, beyond the scenario itself, other pieces of information are needed to describe a full simulation setup and test case. ASAM OpenSCENARIO **cannot be regarded as a complete specification of a simulator**, its system under test or, its test case. The following features specifically are not considered in scope for ASAM OpenSCENARIO:

|Feature|Description|
|-|-|
Test configuration description|ASAM OpenSCENARIO does not describe a test instance or its structure.
Test case language|ASAM OpenSCENARIO does not specify all possible user or system interactions with a vehicle.
Test evaluation|ASAM OpenSCENARIO does not include concepts for creating test verdicts, although it contains methods for the evaluation conditions for triggering actions.
Driver model|ASAM OpenSCENARIO does not include behavioral driver models, except for basic concepts, such as the physiological description of a driver.
Vehicle dynamics|ASAM OpenSCENARIO does not include elements to describe advanced motion dynamics for vehicles.
Environmental models|ASAM OpenSCENARIO includes elements to define environmental properties, such as the current time or the weather, but does not specify how this is to be interpreted by a simulator.
|

### Conventions and notations

#### Normative and non-normative statements

#### Naming conventions

#### Units

#### Data types

#### Modal verbs

#### Typographic conventions

### Deliverables

### Revision history

### Changelog

### Complementary standards and formats

ASAM OpenSCENARIO can be complemented by other logical road network and 3D model formats. The following list gives some examples:

- Logical road network

  - Navigation Data Standard (NDS) [5]

- 3D models of road, scenery and objects

  - CityGML [6]

  - OpenSceneGraph [7]

  - glTF (Khronos Group) [8]

  - FBX (Autodesk) [9]

  - 3ds (Autodesk) [10]

## 1. Scope

ASAM OpenSCENARIO specifies the modeling approach how to **describe dynamic content** in driving application simulations using the Extensible Markup Language (XML).

- The ASAM OpenSCENARIO standard

  - specifies the schema for ASAM OpenSCENARIO in an UML model and an XSD schema. The UML model and the XSD schema defines the structure, sequence, elements, and values of ASAM OpenSCENARIO. The XSD schema is derived from the UML model.

  - provides the XSD schema to which valid ASAM OpenSCENARIO files shall conform.

  - explains how the ASAM OpenSCENARIO elements are used and relationships between elements in the ASAM OpenSCENARIO UML model and XSD schemas, for example, actions, entities, a road network, and triggers.

## 2. Normative References

## 3. Terms and definitions

### Ego vehicle

The vehicle(s) that is (are) the focus of a scenario, meaning the vehicle(s) under test. For evaluation of automated driving systems, the Ego vehicle is the vehicle controlled by the system-under-test. For human driver experiments, the Ego vehicle is the vehicle driven by the human driver. There may be zero, one, or multiple Ego vehicles within a scenario.

### Parameterization

The use of parameters, which are symbols that may be replaced by concrete values at a later stage according to either user needs or stochastic selection.

### World

Everything that falls within the spatial extent of a scenario and therefore may form a part of the scenario description.

## 4. Abbreviations

## 5. Backward compatibility

## 6. General concepts

### 6.1. Architecture

#### 6.1.1. Basic architecture components

The ASAM OpenSCENARIO architecture contains the following basic components:

- An OpenSCENARIO Model Instance (OSC Model Instance) represents a scenario description in the solution space defined by the data model.

- An OpenSCENARIO Director (OSC Director) is a component that interprets the OSC Model Instance and governs the progress of a scenario in a simulation. The OSC Director is the component responsible for running the scenario.

- A Simulator Core. The Simulator Core is defined as all components other than OSC Director or OSC Model Instance that are needed to run a simulation. The Simulator Core is an external concept to ASAM OpenSCENARIO and provides an not standardized interface to the OSC Director for orchestrating the traffic situations defined in the scenario.

#### 6.1.2. ASAM OpenSCENARIO elements

OSC Director and Simulator Core both manage the lifecycle of **elements** within their respective scope. An element is an object instance that exists either in the OSC Director or in the Simulator Core and may change its state during the execution of a scenario. **ASAM OpenSCENARIO clearly states which elements shall be encapsulated in an OSC Director and which elements are managed by a Simulator Core**.

##### Elements of the OSC Director

The OSC Director manages the lifecycle of the following elements:

- Storyboard (1 per scenario)

- Story instances (0..* per Storyboard)

- Act instances (1..* per Story)

- ManeuverGroup instances (1..* per Act)

- Maneuver instances (0..* per ManeuverGroup)

- Event instances (1..* per Maneuver)

- Action instances (1..* per Event)

The OSC Director performs the nested and concurrent execution of the elements above. This includes:

- Forking into different execution paths.

- Joining from different execution paths.

- Loop execution (ManeuverGroup , Event) for maximumExecutionCount > 1.

##### Elements in the Simulator Core

ASAM OpenSCENARIO also requires an abstract understanding of elements that are not under the responsibility of the OSC Director at runtime. These are:

- Entities representing traffic participants, such as vehicles and pedestrians

- Environmental parameters, such as time of day, weather, and road conditions

- Traffic signal controllers and traffic signals

- Traffic objects, such as swarms of vehicles, sources for vehicles, and sinks of vehicles

- Controllers: Default controllers, user-defined controllers like simulated drivers, drivers in the loop, or for the appearance of the ScenarioObject

- Control strategies: Entity control instructions that originate from actions

- Variables and user defined values

##### Element states

Elements generally have a set of property values at runtime. Because properties and relations, for example speed and position, may change during the simulation the complete set of property values and relations at a specific time represents the state of an element.

##### Static elements

A static element is a stateless component that does not change during runtime. Examples of static elements are the road network and road surface descriptions. These resources may be shared between OSC Director and Simulator Core.

#### 6.1.3. Executing a scenario

Executing a scenario synchronizes the state of the elements in the OSC Director with the state of the elements in the Simulator Core.

The OSC Director interprets the OSC Model Instance at runtime, which translates in commands to the Simulator Core. The Simulator Core handles its elements, whose states are used by the OSC Director, to guide the developing scenario in the directions prescribed by the OSC Model Instance.

As an example, the SpeedCondition can be used via its application in a startTrigger to couple the speed of an entity managed by the Simulator Core to the start of an event that is managed by the OSC Director.

#### 6.1.4. Actions and conditions

Actions and Conditions are abstract concepts that enable an OSC Director to interact with the Simulator Core and thus manage the ongoing simulation in accordance with the OSC Model Instance. Actions are used to manage the simulation by targeting the behavior of traffic simulation elements in Simulator Core. Conditions evaluate the state of traffic simulation elements in Simulator Core.

#### 6.1.5. Abstract ASAM OpenSCENARIO architecture

With the definition of actions and conditions, the logical interface between OSC Director and Simulator Core can be refined into an Apply Action Interface and an Evaluate Condition Interface. More generic interfaces are also required for general commands like initialize, starting, and stopping a simulation. Figure 4 illustrates the architecture of ASAM OpenSCENARIO.

### 6.2. Road networks and environment models

A scenario description may require references to a specific road network as well as inclusion of specific 3D models that represent the simulated environment visually. The definition of road network logic and/or environment 3D models is **optional** of ASAM OpenSCENARIO. Those references are established within the **RoadNetwork language element**. As an example, the ASAM **OpenDRIVE** file format is common when it comes to describing road network logic.

Scenario authors often need to refer to items defined in the road network, for example, **to instruct a vehicle to drive in a specific lane**. ASAM OpenSCENARIO does not impose its own naming system for these items; they should be referred with the names allocated by their own file format.

The following features of the road network may be addressed using ASAM OpenSCENARIO:

- Individual road

- Lane within a road

- Traffic signal

- Traffic signal controller

- Road object

As mentioned before, a road network description supported by ASAM OpenSCENARIO is the ASAM OpenDRIVE format. This format describes the logical information related to road structure, such as road id, lane id, and road geometry. This information may be used to locate and position instances of Entity acting on the road and to position traffic participants. If ASAM OpenDRIVE is used to represent the road network, the ASAM OpenSCENARIO file should follow the ASAM OpenDRIVE conventions for numbering lanes.

### 6.3. Coordinate systems

In ASAM OpenSCENARIO, the following coordinate system types are defined:

- A coordinate system that consists of three orthogonal directions associated with X, Y, and Z axes and a coordinate origin where axes meet, defines the **right-handed** Cartesian coordinate system. It is compliant with the ISO 8855:2011 [11] definition. Orientation of road objects is expressed extrinsically by the **heading (yaw)**, **pitch**, and **roll** angles derived from the sequence of rotations in the order: Z-axis, then Y-axis, then X-axis. The positive rotation is assumed to be counter-clockwise ("right-hand rule", see Figure 5):

- A **road-based coordinate system** that consists of two coordinate axes associated with the reference line of the corresponding road (s-axis) and the direction orthogonal to it (t-axis) and pointing leftwards. The definition of the s- and t-axes depends on the reference part of the road in use (see Figure 6):

- A coordinate system associated with **positions on the earth** and defined by the corresponding terrestrial reference system (geodetic datum) in use.

#### 6.3.1. World coordinate system (Xw, Yw, Zw)
 
Coordinate system of type (X, Y, Z) fixed in the inertial reference frame of the simulation environment, with Xw and Yw axes parallel to the ground plane and Zw axis pointing upward.

Neither origin nor orientation of the world coordinate system are defined by the ASAM OpenSCENARIO standard. If a road network is referenced from a scenario, the world coordinate system is aligned with the inertial coordinate system present in this description (in particular, the Zw-coordinate is assumed to consider a road elevation, an entire road super-elevation, or a lateral road shape profile).

#### 6.3.2. Road coordinate system (s/t)

To every road specified in the road network definition document (external to ASAM OpenSCENARIO), there is a s/t-type coordinate system assigned. The road reference line defines the s-axis belonging to the (X,Y)-plane of the world coordinate system. The shape of the s-axis line is flat and determined by the geometry of the road projected on the (X,Y)-plane (Z-coordinates equal to 0). The origin of s-coordinates are fixed at the beginning of the road reference line and not affected by an elevation of the road (its inclination in the s-direction).

In contrast, multiple t-axes can be defined along the s-axis. Each t-axis points orthogonally leftwards to the s-axis direction and originates on the s-axis at the point with the concerned s-coordinate. All t-axes lie on the surface which is derived from the road surface as if its elevation were not considered. Therefore, t-axes adopt a lateral slope of the road as they are oriented coplanar to the road surface. As the consequence, t-coordinates are not affected by a superelevation of the road.

The following constraints are defined:

- It is assumed the s-axis line has a smooth shape (no leaps nor kinks).

- Being two-dimensional by its nature, the Road coordinate system does not define any vertical positioning. This means positions, specified with (s/t)-coordinates, are on the road surface.

- Both s- and t-coordinates are applicable within boundaries of the respective road only.

- In the case of multiple chained roads, each road defines its own s-axis.

- In the case of roads with a complex lateral profile (for example, uneven surface), applicability and conversion of s/t-coordinates into other coordinate systems might appear problematic or even impossible.

#### 6.3.3. Lane coordinate System (s/t)

#### 6.3.4. Vehicle coordinate system (Xv, Yv, Zv)

The vehicle axis system of type (X, Y, Z), as defined in ISO 8855:2011 [11], is fixed in the reference frame of the vehicle sprung mass. The Xv axis is horizontal and forwards with the vehicle at rest. The Xv axis is parallel to the vehicle’s longitudinal plane of symmetry. The Yv axis is perpendicular to the vehicle’s longitudinal plane of symmetry and points left. The Zv axis points upward.

In ASAM OpenSCENARIO, the origin of this coordinate system is derived by projecting the center of the vehicle's **rear axis** to the ground plane at neutral load conditions. The origin remains fixed to the vehicle sprung mass, as illustrated in Figure 7.

#### 6.3.5. Pedestrian / MiscObject coordinate system (Xp/m , Yp/m , Zp/m)

The axis system for a pedestrian (subscript p) or a miscellaneous object (subscript m) is fixed in the reference frame of the object’s bounding box. The X axis is horizontal and normal to the object’s front plane. The Y axis is horizontal, perpendicular to X, and points to the left. The Z-axis points upward.

The origin of this coordinate system is derived from the geometrical center of the object’s bounding box under neutral load conditions (if applicable) projected onto the ground plane.

#### 6.3.6. Trajectory coordinate system (s/t)

To every trajectory specified within the scenario, there is a s/t-type coordinate system assigned. The trajectory is deemed as an imaginary spatial directed line ("trajectory line") on the road surface indicating a movement path. The geometry of the trajectory line defines the s-axis course and shape. The origin of s-coordinates is fixed to the beginning of the trajectory line which can go through multiple chained roads.

In contrast, multiple t-axes can be defined along the s-axis. Each t-axis points orthogonally leftwards to the s-axis direction and originates on the s-axis at the point with the concerned s-coordinate. All t-axes lie on the surface of the road and therefore adopt a lateral slope profile and an elevation of the road.

The following constraints are defined:

- Being two-dimensional by its nature, the Trajectory coordinate system does not define any vertical positioning. This means positions, specified with (s/t)-coordinates, are on the road surface.

- S-coordinates are applicable within the length of the respective trajectory line only.

- T-coordinates are applicable within boundaries of the respective road only.

- If a trajectory line has a polyline shape, t-axes are undefined at points where the line has sharp kinks.

- In the case of roads with a complex lateral profile (for example, uneven surface), applicability and conversion of s/t-coordinates into other coordinate systems might appear problematic or even impossible.

#### 6.3.7. Geographic coordinate system (latitude, longitude, altitude)

ASAM OpenSCENARIO accepts position coordinates expressed in spherical geographic coordinate systems as longitude, latitude, and altitude. Interpretation of geographic coordinates might depend on the reference geoid model (datum) used in the geographic coordinate system and is therefore **external to** ASAM OpenSCENARIO.

The world coordinate system is considered the projected coordinate system compatible with the ENU (East, North, Up) convention of the X/Y/Z-axis directions and is derived from the used geographic coordinate system that is based on the applied geoid model. The (X,Y)-plane of the world coordinate system is assumed to be a local tangent plane in relation to the surface of the reference geoid model.

If coordinates of positions are derived from the geographic coordinate system, the road network definition shall specify the map projection system type involved and provide its mandatory parameters.

#### 6.3.8. Positioning

ASAM OpenSCENARIO provides various ways to position or localize instances of Entity acting in the scenario:

- Absolute in the world coordinate system

- Absolute/relative in the geographic coordinate system

- Relative to another Entity

- Absolute/relative in the road coordinate system

- Absolute/relative in the lane coordinate system

- Relative to a Route

- Relative to a Trajectory

### 6.4. Distances

ASAM OpenSCENARIO interprets distances in special ways. To properly use instances of Action and Condition, it is important to understand distance interpretation.

Depending on the use case, a distance may be specified between:

- Two points

- A point and an Entity (with or without bounding box considerations)

- Two entities (with or without bounding box considerations)

Distances in ASAM OpenSCENARIO may be measured in two ways:

- From a local coordinate system, with lateral and longitudinal distance in an Entity, road, lane, or trajectory coordinate system

- In absolute context, that is Euclidean distance

#### 6.4.1. Visualization

#### 6.4.2. Referring to distances in ASAM OpenSCENARIO

In ASAM OpenSCENARIO, lateral and longitudinal distance depends on the type of referential, for example Entity, road, lane, or trajectory. Euclidean distance is measured in a global context.

#### 6.4.3. Euclidean distance

Euclidean distance between two points in Euclidean space is the length of a line segment between those two points, as shown in Figure 9. It is unambiguously defined in ℝ3, independently from the coordinate system that describes the coordinates.

#### 6.4.4. Distances in an entity coordinate system

Given two points A = (XA , YA , ZA) and B = (XB , YB , ZB) in the coordinates of a specific Entity, the definition in ASAM OpenSCENARIO is:

- Longitudinal Entity distance - (dXAB): |XB - XA |

- Lateral Entity distance - (dYAB): |YB - YA |

#### 6.4.5. Distances in road coordinates

Given two points in road coordinates A = (sA , tA , hA) and B = (sB , tB , hB), the definition in ASAM OpenSCENARIO is:

- Longitudinal road distance: dsAB: |sB - sA|

- Lateral road distance: dtAB: |tB - tA|

#### 6.4.6. Lane distance and trajectory distance

Distances based on the lane or trajectory referentials are measured using the same methods as distances measured in the road referential.

- Distances measured in the lane referential use the lane center as a reference line, rather than the road reference line.

- Distances measured in the trajectory referential use the trajectory as a reference line, rather than the road reference line.

#### 6.4.7. Involving an entity in a distance calculation

In addition to distances between two points, ASAM OpenSCENARIO also support distance measurement between two entities or between an entity and a point. In both cases, it is important to identify the two points of interest and apply the distance concepts introduced in this chapter.

Identifying the point of interest for an Entity depends on the value of the Boolean attribute freeSpace. It determines whether the entities bounding box shall be taken into consideration (freeSpace = true), or shall not be taken into consideration (freeSpace = false).

##### freeSpace = false

In this case, the **bounding boxes of the entity shall not be considered**. The point of the entity used to calculate the distance is the entity's origin.

##### freeSpace = true

In this case, the bounding boxes of the Entity shall be considered. Which point is chosen depends on the desired distance type.

#### 6.4.8. Guideline for positions on different roads

##### Longitudinal distance

###### Road coordinate system

The longitudinal distance can only be calculated when the path between start and target positions forms an unambiguous chain of consecutive road reference lines (s-axes). In the case of ambiguity, a helping route can be defined so that both start and target positions are found on the same route (see for more the section Section 6.4.8.3).

When calculating the longitudinal distance, breaks of road reference lines (also known as s-axes) of directly connected roads do **not affect the result**.

The longitudinal distance is calculated as a **sum of lengths of segments** along the chained road s-axes between projections of start and target positions on respective s-axes.

###### Lane coordinate system

###### Trajectory coordinate system

##### Lateral distance

###### Road coordinate system

In the case, reference lines of connected roads along the chain are not contiguous, the lateral distance is not meaningful and therefore **undefined**.

###### Lane coordinate system

The lateral distance is undefined.

###### Trajectory coordinate system

##### Helping route

### 6.5. Speed

Speed is measured as the magnitude of the speed vector in the vehicle coordinate system, consisting of longitudinal and lateral speed components.

### 6.6. Controllers

Controller are elements of the simulation core that control the **motion or appearance** of a ScenarioObject. ASAM OpenSCENARIO does **not specify how controllers work and how they are implemented**. ASAM OpenSCENARIO considers a controller as a **runtime element** that is used to enforce the control strategies (see Section 7.4.1.1) assigned to instances of ScenarioObject.

Any number of Controller elements can be assigned to objects of type Vehicle or Pedestrian.

A Controller may be internal, as a part of the simulator, or external, defined in a file. The intended use cases for controllers are:

- Specifying that a vehicle is controlled by the system under test.

- Defining **smart actor behavior**, where a controller takes intelligent decisions in response to the road network or other actors. Hence, controllers can be used, for example, to make agents in a scenario behave in a human-like way.

- Assigning a vehicle to direct **human control**.

By default, controllers are assigned in a deactivated state.

#### 6.6.1. Controller types

ASAM OpenSCENARIO defines four different domains of a Controller:

- Longitudinal

- Lateral

- Lighting

- Animation

ASAM OpenSCENARIO defines two types of controllers:

- The default controller that enforces control strategies exactly as they are described by the actions

- A user-defined controller that may have custom interpretations of control strategies

ASAM OpenSCENARIO **cannot prescribe** the behavior of an user-defined controller. This means that simulations with user-defined controllers can differ from simulations generated using only default controllers, even though they use the same OSC Model Instance. This allows the scenario designer to use ASAM OpenSCENARIO in a broader scope, interpreting Action as suggestions rather than commands. Repeatable simulation results are only expected when using default controllers.

#### 6.6.2. Controlling a scenario object

#### 6.6.3. Assigning a user-defined controller

#### 6.6.4. Activating a user-defined controller

#### 6.6.5. Assigning the default controller

#### 6.6.6. Activating the default controller

### 6.7. Appearance

### 6.8. Routes

A **Route** is used to **navigate** instances of Entity through the **road** network based on a list of **waypoints** on the road that are linked in a specific order, resulting in directional route. A **Waypoint consists of a position and a RouteStrategy**. The RouteStrategy indicates how to reach the position. An Entity's movement between the waypoints is created by the simulator which uses the RouteStrategy as constraint. There may be more than one way to travel between a pair of waypoints. If this is the case, the RouteStrategy specified in the target Waypoint shall be used.

The different available and simulator-specific options for RouteStrategy are:

- Fastest: Selects the route with the shortest travelling time between start and target location.

- Least intersections: Selects the route with as few junctions as possible between start and target location.

- Random: It is up to the simulator how to reach the target location.

- Shortest: Selects the route with the shortest path between start and target location.

### 6.9. Trajectories

Instances of Trajectory are used to define an intended path for Entity motion in precise mathematical terms. The motion path may be specified using different mathematical shapes:

- Polyline: A concatenation of simple line segments across a set of vertices.

- Clothoid: Euler spiral, meaning a curve with linearly increasing curvature.

- Non-Uniform Rational B-Splines (Nurbs) of arbitrary order.

By using nurbs, most relevant paths may be expressed either directly or with arbitrary approximation: Nurbs curves form a strict superset of the curves expressible as Bézier curves, piecewise Bézier curves, or non-rational B-Splines, which can be mapped to corresponding nurbs curves. Because nurbs curves directly support the expression of conic sections, such as circles and ellipses) approximation of, for example clothoids using arc spline approaches, is feasible.

Also, nurbs make it relatively easy to ensure continuity up to a given derivative: A nurbs curve of degree k, meaning order k+1, is infinitely continuously differentiable in the interior of each knot span and k-M-1 times continuously differentiable at a knot. M is the multiplicity of the knot, meaning the number of consecutive knot vector elements with the same value.

Commonly used nurbs curves are curves of quadratic (order = 3) and cubic (order = 4) degree. Higher-order curves are usually only required if continuity in higher derivatives needs to be ensured. Because the effort for evaluating curves increases with rising orders, it is recommended to restrict instances of Trajectory to lower orders.

Instances of Trajectory may be specified using just the three-positional dimensions along the X, Y, and Z axes (see Section 6.3 for coordinate system definitions). Alternatively, instances of Trajectory may also be specified using the three-positional dimensions and the three-rotational dimensions (heading, pitch and roll) for six total dimensions. In the second case, the path not only specifies the movement of the entity along the path, but also the orientation of the corresponding entity during that movement.

When a Trajectory is specified relative to the position of a moving entity, its absolute position cannot be calculated before the scenario starts. In this case, the trajectory must be calculated at runtime when the corresponding FollowTrajectoryAction is triggered.

Additionally, an instance of Trajectory may be specified with or without a time dimension, allowing for the combined or separate specification of the entities longitudinal domain: A trajectory incorporating the time dimension completely specifies the motion of the entity, including its speed. A trajectory without the time dimension does not specify the speed along the path. This approach allows for the separate control of speed.

A Trajectory provides a mathematically precise definition of a motion path. The corresponding entities behavior, however, depends on the actions employing it: Either an Entity follows this path exactly or it uses the path as a guidance for the controller to follow as best as the entities rules of motion allow.

The following sections describe edge cases in the definition of trajectories.

##### 6.9.1. Entity is not at the start of trajectory, timeReference is not set

Starting conditions:

- When the FollowTrajectoryAction starts, the entity is not at the beginning of the trajectory.

- Time references are not set.

Expected behavior:

- If the followingMode is position, the entity teleports to the beginning of the trajectory.

- If the followingMode is follow, the controller attempts to steer as close to the trajectory as possible. Because the timeReference is not defined, the controller steers towards the point that bring the entity in line with the trajectory as soon as feasible. Considering the current position, orientation, and performance limitations of the entity, this is possibly not the start point of the trajectory, and maybe not even the geometrically closest point, as shown in Figure 19.

##### 6.9.2. Entity is not at the start of trajectory, timeReference is set (in the future)

...

##### 6.9.3. Entity is not at the start of trajectory, timeReference is set (in the past)

...

##### 6.9.4. Entity is at an ambiguous point near the trajectory

...

##### 6.9.5. Trajectory-relative positions

...

### 6.10. Traffic simulation

In addition to deterministic behavior of instances of Entity, ASAM OpenSCENARIO also provides ways to define stochastic or not precisely defined behavior. This can be useful for the following purposes:

- Make the scenario more realistic.

- Induce variances into the scenario sequence.

- Define traffic parameters, such as traffic density.

To define stochastic behavior, surrounding intelligent traffic agents may be defined using instances of TrafficAction. With the help of this action, the parameterization of traffic sources, traffic sinks, and traffic swarms may be specified.

The definition of a TrafficAction in ASAM OpenSCENARIO does not specify which maneuvers the intelligent traffic agents execute. Instead, those actions specify the initialization or termination of vehicles whose behavior is controlled by external traffic simulation models. Spawned traffic participants makes routing decisions based on their corresponding driver model, just as with the ActivateControllerAction.

### 6.11. Traffic signals

...

### 6.12. Variables

Variables in ASAM OpenSCENARIO are similar to variables in programming languages. They have the following characteristics:

- Variables are defined in the scope of the whole scenario. All variables that are used in a scenario shall be defined in a VariableDeclaration.

- Variables are named and typed. The same naming rules apply to variables as to parameters (see Section 9.1).

- Variables have an initialization value. They are set to their initialization value at load time of the simulation.

Unlike parameter values (see Section 9.1), variable values can also change during runtime. This can be achieved in two ways:

- From within the scenario (OSC Model instance) by using a VariableAction

- From external side. For this, the Simulator Core needs to provide an interface to change variable values.

### 6.13. Properties

Instances of Property may be used to define test-instance specific or use-case specific properties of ASAM OpenSCENARIO sub-elements. Properties are available for the following types:

- Vehicle

- Pedestrian

- MiscObject

- Controller

- RoadCondition

- FileHeader

## 7. Components of a scenario

### 7.1. Overview of a scenario

To represent a traffic situation, an OSC Model Instance is built up of four main components:

- Road network: mapping of the different driving surfaces and all relevant elements of the road infrastructure, like traffic signals.

- Entities: road users, including vehicles, pedestrians, and other miscellaneous objects that interact during a scenario.

- Actions: basic building blocks to define dynamic behavior of the entities. It may also be used to modify simulation states or components of the simulated world.

- Triggers: mechanism that determines when an action starts or stops. It is built on logical expressions revolving around the states of entities or the simulation.

The structure of the OSC Model Instance was created with the purpose to host and combine the main components listed above in such a way that rich driving scenarios can be defined. This chapter introduces the ASAM OpenSCENARIO structure, how the different components fit in the structure, and how these components relate to one another.

### 7.2. Storyboard and entities

#### 7.2.1. Storyboard

In ASAM OpenSCENARIO, the **storyboard covers the complete scenario description**. The storyboard provides the answers to the questions "who" is doing "what" and "when" in a scenario. An ASAM OpenSCENARIO Storyboard element consists of the following elements:

- Init: Initialization element that sets the initial states of the scenario elements, such as the position and speed of instances of Entity. It is not possible to specify conditional behavior in this section.

- One or more Story elements (optional): Story elements enable scenario authors to group different scenario aspects into a higher-level hierarchy and thus create a structure for large scenarios.

- stopTrigger: determines the end of the scenario.

Instances of Story in ASAM OpenSCENARIO contain Act instances, which in turn define conditional groups of Action instances. Each **act** focuses on answering the question **"when"** something happens in the timeline of its corresponding story. The act regulates the story via its startTrigger instance and its stopTrigger instance. If a startTrigger evaluates to true, the act’s ManeuverGroup instances are executed.

A **ManeuverGroup** element is part of the Act element and addresses the question of **"who"** is doing something, by assigning entities as Actors (see Section 7.3.1) in the included Maneuver instances. Maneuver groups may also include catalog references with predefined maneuvers. This concept is described in Section 9.4.

The **Maneuver** element defines **"what"** is happening in a scenario. A Maneuver is a container for Event instances that need to share a common scope. Events control the simulated world or the actors defined in their parent maneuver group. This is achieved through triggering Action instances, via user-defined Condition instances.

#### 7.2.2. Entities

In a scenario, instances of Entity are the participants that make up the developing traffic situation. Vehicle, Pedestrian, and MiscObjects instances may change their location dynamically. A MiscObject instance represents an object, such as tree or pole. The possible categories are identical to the ones that are defined in ASAM OpenDRIVE. If an object is already defined in the road network file, it can be instantiated in the scenario as Entity as ExternalObjectReference.

Instances of Entity may be specified in the scenario format but the properties are specific to their type. For example, a Vehicle is an instance of Entity that has properties like vehicleCategory and performance. In contrast, a Pedestrian is specified by a property pedestrianCategory.

##### Motion control for entities

...

##### Entity selections

...

##### Spawned objects

An entity may be represented by a single ScenarioObject instance or by an EntitySelection instance. Both, ScenarioObject and EntitySelection instances, are declared in the scenario file and are globally identified by their name attribute when they are used in actions and conditions. An entity may also be represented by a **SpawnedObject instance which is created by a traffic source**. These objects are created dynamically and have no static name that would enable a scenario author to reference them explicitly in a defined entity condition or in a private action.

##### Entity class hierarchy

The Entity class hierarchy provides an overview of the relations between Entity, EntitySelection, EntityRef and SpawnedObject.

##### Generalization of entities

ASAM OpenSCENARIO relates the Vehicle, Pedestrian, MiscObject, and EntitySelection classes in the generalized concept Entity. This is useful because the concept of entity provides the building blocks for many actions and conditions - for example: A CollisionCondition instance can model the collision between a Vehicle instance and a MiscObject instance, such as a tree.

##### 3D models for entities

### 7.3. ManeuverGroups, Events and Maneuvers

#### 7.3.1. ManeuverGroups and Actors

#### 7.3.2. Events

Actions are singular elements that may need to be combined to create meaningful behavior in a scenario. This behavior is created by the type **Event** which serves as a **container for actions**. Events also incorporate start triggers. The event start trigger determines when the event starts and when the actions contained in the event, start.

#### 7.3.3. Maneuver

A **maneuver groups events** creating a scope where the events can interact with each other using the event priority rules. The definition of a maneuver may be outsourced to a catalog and parameterized for easy reuse in a variety of scenarios.

### 7.4. Actions

Actions enable ASAM OpenSCENARIO to prescribe element behavior in traffic simulations or to directly affect element states, which in turn determine how a simulation evolves. An Action instance is defined in a OSC Model Instance.

#### 7.4.1. Private action

...

#### 7.4.2. Global action

...

#### 7.4.3. User-defined action

...

### 7.5. Actions at runtime

...

### 7.6. Conditions and triggers

A scenario can be regarded as a collection of meaningful **actions** whose **activation is regulated by triggers**. These triggers play an important role on how a scenario evolves because the same set of actions may lead to a multitude of different outcomes. The outcome strongly depends on how actions are triggered in relation to one other. In ASAM OpenSCENARIO, **a trigger is the outcome arising from a combination of conditions and always evaluates to either true or false**.

In ASAM OpenSCENARIO, **a condition is a container for logical expressions** and is assessed at runtime. The condition operates on the **current and previous** evaluations of its logical expressions to produce a Boolean output that is used by triggers.

#### 7.6.1. Triggers and condition groups

The `Trigger` class is an association of `ConditionGroup` instances, which are an association of `Condition` instances. At runtime, a condition group evaluates to either true or false and its outcome is calculated as the **AND** operation between all its conditions:

A conditionGroup is evaluated to true when all its associated conditions are evaluated to true.

The outcome of a trigger is calculated as the **OR** operation between all its condition groups.

A trigger evaluates to true when at least one of its condition groups evaluates to true.

##### Start trigger

An **instance of** the `Trigger` class instantiated as a start trigger is used to move a runtime instantiation of a `Storyboard` **element** from the `standbyState` to the `runningState`. **Only the `Act` class and `Event` class host start triggers** and any element that does not contain a start trigger **inherits** the start trigger from its parent element. For example, **starting an act also starts its maneuver groups and maneuvers**, but **does not start the events** because the events have their own start triggers. Furthermore, **no events may start if they do not belong to an act that is in the `runningState`**.

The `Story` class is an exception to the rules above since it does not require a formal start trigger given that **starting a simulation is equivalent to starting the `Story`**.

##### Stop trigger

A stop trigger is used to force a runtime instantiation of a `StoryboardElement` to transition from its `standbyState` or `runningState` to the `completeState`. **Only the storyboard and the act host stop triggers**. All storyboard elements **inherit** the stop triggers from their parent. This is true **even if the storyboard element under consideration has its own stop triggers**. For example, if a story is affected by a stop trigger, so are all its acts, even though they have their own stop triggers.

When a stop trigger is received, the concerned storyboard element is expected to transition to the `completeState` with a `stopTransition`, and clear all remaining number of executions, if applicable. If the trigger occurs when the element is in the `runningState`, it is expected that its execution is terminated immediately.

#### 7.6.2. Condition edges

When edges are defined, with `rising`, `falling`, and `risingOrFalling`, the condition evaluation is also dependent on past values of its logical expression at the discrete time $t_{d-1}$. 

...

#### 7.6.3. Condition delay

A delay is a modification of a condition that allows **past values of the condition evaluation** to be used in the present $t_{d}$. When a delay $\Delta t$ is defined, a condition at time $t_{d}$ is represented by the evaluation of the logical expressions associated to that condition, at $t_{d} - \Delta t$, rather than the evaluation of its logical expressions at time $t_{d}$. In other words, evaluation of a delayed condition at time $t_{d}$ it is equivalent to the evaluation of a similar condition, but without delay, at time $t_{d} - \Delta t$:

$C_{D}\left(t_{d}\right) = C\left(t_{d - \Delta} \right)$

#### 7.6.4. Corner cases of edges and delays

Both edge and delay concepts rely on previous evaluations of the logical expression of a condition. Depending on when the condition is evaluated, these previous evaluations of the logical expression **may not be available**.

The first time a condition defined with `edge` is checked, there is no information about previous evaluations of its logical expression. At runtime, a condition defined with `edge` shall **always evaluate to false**, the first time it is checked. ASAM OpenSCENARIO expects a condition to be checked for the first time once its enclosing storyboard element enters the `standbyState`. If `standbyState` is not defined, `runningState` shall be used.

In case of conditions defined with delay, if $t_{d} < \Delta t$, the concerned condition evaluates to false.

#### 7.6.5. Condition types

The base condition type contains three basic elements: `name`, `delay`, and `conditionEdge`. Whereas the first element is self-explanatory, clarification on the other terms is given in the preceding sections. Other elements of a condition depend on its subtype, of which there are two: `ByEntityCondition` and `ByValueCondition`.

##### ByEntityConditions

The `ByEntityCondition` class hosts classes of conditions which use the **states entities** to perform the conditional evaluation. The conditional evaluation may depend on the value of a single state, or on how the value of any one given state relates to another state. The other state may be:

- within the entity

- between entities

- between the entity and the corresponding characteristics of the road network

Entity conditions require the definition of triggering entities whose states are used in the conditional evaluation. If more than one triggering entity is defined, the user is given two alternatives to determine when the condition evaluates to true: either all triggering entities verify the logical expression or at least one entity verifies the logical expression.

##### ByValueConditions

The `ByValueCondition` classes hosts condition classes with logical expressions that depend on **simulation states** rather than **entity states**. Examples are scenario states, times, and traffic signal information.

Value conditions also provide a **wrapper** for external conditions that may depend on values that are not accessible from the scenario and are only available to the user implementation. Examples are pressing buttons, custom signals, and commands.

## 8. Scenario at runtime

This section covers the expected runtime behavior of the Storyboard and its nested elements in a simulation.

...

## 9. Reuse mechanisms

...

## 10. Tutorial: How to create a scenario

### 10.1. Example description of a scenario

The file for the sample scenario used in this tutorial is named SimpleOvertake.xosc. The file is located in the examples directory.

### 10.2. Entities

In the Entities section, we define the traffic participants used in the scenario: one or more instances of Vehicle, Pedestrian, MiscObject, or ExternalObjectReference.

### 10.3. Init section

The following XML example shows multiple instances of Action that position the entities Vehicle 1 and Vehicle 2 using road coordinates and define initial velocities. Vehicle 1 has speed 150 km/h and is located 58 m behind Vehicle 2, which has speed 130 km/h.

### 10.4. Stories

Instances of Story may be used to group **independent parts of the scenario**, to make it easier to follow. In this example, we need only one Story. If an Act is moved from one Story to another, the scenario works in the same way, as long as there are no naming conflicts.

### 10.5. Acts

An Act allows a set of multiple instances of Trigger to determine when the specific Act starts.

### 10.6. ManeuverGroups

Using ManeuverGroup we specify the Actors that are executing the actions. Because we want Vehicle 1 to change lanes, we specify its name under Actors. This means that all the actions under this ManeuverGroup are executed by Vehicle 1.

### 10.7. Maneuvers

In this example, one Maneuver is used to group two instances of Event.

### 10.8. Events and actions

Under Maneuver_1 we define two instances of Event, one for left lane change called Turn left and the other one with right lane change named Turn right. Left and right means relative to the current lane.

### 10.9. Sequential execution

...

### 10.10. Traffic signal

...

## 11. Examples

...

