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

# Introduction

## Overview

The primary use of ASAM OpenSCENARIO is the description of complex maneuvers that involve multiple vehicles.

The standard may be used in conjunction with ASAM OpenDRIVE [1] and ASAM OpenCRG [2], which describe static content in driving simulation.

### What is a scenario?

A scenario is a description of how the view of the world changes with time, usually from a specific perspective.

In a simulation context, a complete scenario is comprised of the following parts:

- Static environment description, including:

  - Logical road network

  - Optionally physical and geometric road and environment descriptions

- Dynamic content description, including:

  - Overall description and coordination of behavior of dynamic entities

  - Optional behavior models of dynamic entities

### What is ASAM OpenSCENARIO?

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

## Conventions and notations

### Normative and non-normative statements

### Naming conventions

### Units

### Data types

### Modal verbs

### Typographic conventions

## Deliverables

## Revision history

## Changelog

## Complementary standards and formats

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

OSC Director and Simulator Core both manage the lifecycle of **elements** within their respective scope. An element is an object instance that exists either in the OSC Director or in the Simulator Core and may change its state during the execution of a scenario. ASAM OpenSCENARIO clearly states which elements shall be encapsulated in an OSC Director and which elements are managed by a Simulator Core.


















