# [esmini user guide](https://esmini.github.io/)

- [esmini user guide](#esmini-user-guide)
  - [1. Introduction](#1-introduction)
  - [2. Getting started](#2-getting-started)
    - [2.1. Run esmini](#21-run-esmini)
    - [2.2. Get complete esmini](#22-get-complete-esmini)
    - [2.3. Build esmini - quick guide](#23-build-esmini---quick-guide)
  - [3. Tools overview](#3-tools-overview)
  - [4. Use cases](#4-use-cases)
    - [4.1. View a scenario](#41-view-a-scenario)
      - [4.1.1. Basic features](#411-basic-features)
      - [4.1.2. Camera control](#412-camera-control)
      - [4.1.3. Some key shortcut commands](#413-some-key-shortcut-commands)
      - [4.1.4. Road network visualization](#414-road-network-visualization)
      - [4.1.5. Background color](#415-background-color)
      - [4.1.6. Anti-alias](#416-anti-alias)
    - [4.2. Screenshots and video clips](#42-screenshots-and-video-clips)
    - [4.3. Logging](#43-logging)
      - [4.3.1. The basic text log file](#431-the-basic-text-log-file)
      - [4.3.2. Scenario recording (.dat)](#432-scenario-recording-dat)
      - [4.3.3. CSV logger](#433-csv-logger)
    - [4.4. Replay scenario](#44-replay-scenario)
      - [4.4.1. Multiple scenarios in parallel](#441-multiple-scenarios-in-parallel)
      - [4.4.2. Save merged .dat files](#442-save-merged-dat-files)
    - [4.5. View road network](#45-view-road-network)
      - [4.5.1. Visualize OpenDRIVE geometry](#451-visualize-opendrive-geometry)
      - [4.5.2. Evaluate OpenDRIVE connectivity](#452-evaluate-opendrive-connectivity)
      - [4.5.3. Inspect OpenDRIVE geometry and road IDs](#453-inspect-opendrive-geometry-and-road-ids)
    - [4.6. Plot scenario data](#46-plot-scenario-data)
    - [4.7. Save OSI data](#47-save-osi-data)
  - [5. Scenario features](#5-scenario-features)
    - [5.1. Speed profile](#51-speed-profile)
      - [5.1.1. Special case: Single entry](#511-special-case-single-entry)
        - [1. Speed can be reached within time](#1-speed-can-be-reached-within-time)
        - [2. Speed can't be reached in time due to acceleration constraints](#2-speed-cant-be-reached-in-time-due-to-acceleration-constraints)
        - [3. Speed can't be reached in time due to jerk constraints](#3-speed-cant-be-reached-in-time-due-to-jerk-constraints)
      - [5.1.2. What if current speed differ from the first entry?](#512-what-if-current-speed-differ-from-the-first-entry)
      - [5.1.3. What if time is missing in entry?](#513-what-if-time-is-missing-in-entry)
      - [5.1.4. Initial acceleration taken into account](#514-initial-acceleration-taken-into-account)
      - [5.1.5. Sharp brake-to-stop profile](#515-sharp-brake-to-stop-profile)
      - [5.1.6. More info](#516-more-info)
    - [5.2. Road signs](#52-road-signs)
      - [5.2.1. The system](#521-the-system)
      - [5.2.2. esmini sign catalogs](#522-esmini-sign-catalogs)
      - [5.2.3. Sign 3D models](#523-sign-3d-models)
      - [5.2.4. Example](#524-example)
    - [5.3. Expressions](#53-expressions)
    - [5.4. Parameter distributions](#54-parameter-distributions)
    - [5.5. Trajectories](#55-trajectories)
  - [6. Controllers](#6-controllers)
    - [6.1. Controller concept](#61-controller-concept)
    - [6.2. Background and motivation](#62-background-and-motivation)
    - [6.3. Brief on implementation](#63-brief-on-implementation)
    - [6.4. How it works for the user](#64-how-it-works-for-the-user)
    - [6.5. The ghost concept](#65-the-ghost-concept)
    - [6.6. esmini embedded controllers](#66-esmini-embedded-controllers)
  - [7. OpenSceneGraph and 3D models](#7-openscenegraph-and-3d-models)
  - [8. Support / Q\&A](#8-support--qa)
  - [9. Build guide](#9-build-guide)
    - [9.1. Build configurations in Visual Studio and Visual Studio Code](#91-build-configurations-in-visual-studio-and-visual-studio-code)
    - [9.2. Build configurations from command line](#92-build-configurations-from-command-line)
    - [9.3. External dependencies](#93-external-dependencies)
    - [9.4. Additional platform dependencies](#94-additional-platform-dependencies)
    - [9.5. Run with Linux and visual studio code](#95-run-with-linux-and-visual-studio-code)
    - [9.6. Debug with Linux and visual studio code](#96-debug-with-linux-and-visual-studio-code)
    - [9.7. Dynamic protobuf linking](#97-dynamic-protobuf-linking)
    - [9.8. Slim esmini - customize configration](#98-slim-esmini---customize-configration)
    - [9.9. MSYS2 / MinGW-w64 support](#99-msys2--mingw-w64-support)
    - [9.10. Build esmini project](#910-build-esmini-project)
      - [Windows/Visual Studio](#windowsvisual-studio)
      - [macOS](#macos)
      - [Linux](#linux)
    - [9.11. CentOS 7 (Linux)](#911-centos-7-linux)
  - [10. Command reference](#10-command-reference)

## 1. Introduction

esmini is a software tool to play OpenSCENARIO files. It's provided both as a stand alone application and as a shared library for linking with custom applications. In addition some tools have been developed to support design and analysis of traffic scenarios.

The scope of this user guide is to provide examples on how to use the tools. It also includes a programming tutorial on how to use esmini in custom applications.

## 2. Getting started

Download latest release from here: https://github.com/esmini/esmini/releases/latest

First time make sure to pick the demo package for your platform (Windows, Linux or Mac). In addition to application binaries it also includes some content like example scenarios and basic 3D models. The binary (bin) packages includes only executables and libraries.

To install the package, just unzip it anywhere. A single subfolder named esmini is created. This is the root folder for esmini. No files are stored outside this folder structure and no system files or registry is modified in any way.

### 2.1. Run esmini

Try to run one of the examples:

go to folder `esmini/run/esmini`

double click on a .bat file, e.g. run_cut-in.bat or run it from a command line.

These scripts should work on all platforms (in spite extension ".bat").

You can also run the examples explicitly from a command line:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc

For common Mac issues, please see [Mac issues and limitations](https://esmini.github.io/#_mac_issues_and_limitations).

### 2.2. Get complete esmini

The demo package contains only a subset of esmini tools and content (e.g. scenario examples, scripts and models).

To get the complete content, first download or clone the project from GitHub: https://github.com/esmini/esmini. E.g:

    git clone https://github.com/esmini/esmini.git

Then either build yourself, see step 2 in next chapter Build esmini - quick guide, or:

1. Download pre-built binary package for your system (e.g. esmini-bin_win_x64.zip) from latest release: https://github.com/esmini/esmini/releases. Copy the content into the esmini-demo folder.

2. Download the complete 3D model package from [here](https://dl.dropboxusercontent.com/s/5gk8bvgzqiaaoco/models.7z?dl=1). Unpack into esmini/resources (it should end up in a `models` subfolder). These assets work on all platforms. The environment models (roads, landscape, buildings…​) have been created using [VIRES Road Network Editor](https://vires.mscsoftware.com/solutions/3d-environment-road-network).

### 2.3. Build esmini - quick guide

Supported systems: Windows, Linux and Mac.

Make sure you have a C++ compiler and CMake installed.

On Windows Visual Studio is recommended (Community/free version is good enough for building esmini). Make sure to check the "Desktop development with C++" package for installation, no more is needed.

On Linux, e.g. Ubuntu, some additional system tools and libraries are needed. Run the following command:

    sudo apt install build-essential gdb ninja-build git pkg-config libgl1-mesa-dev libpthread-stubs0-dev libjpeg-dev libxml2-dev libpng-dev libtiff5-dev libgdal-dev libpoppler-dev libdcmtk-dev libgstreamer1.0-dev libgtk2.0-dev libcairo2-dev libpoppler-glib-dev libxrandr-dev libxinerama-dev curl cmake

Now we're ready to build esmini. From esmini root folder:

    mkdir build
    cd build
    cmake ..
    cmake --build . --config Release --target install

The build process automatically downloads 3rd party library binaries and the complete 3D model package.

After successful build, the binaries will be copied into esmini/bin folder. Try from command line:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc

That's all. Details and variants, see [Build guide](https://esmini.github.io/#_build_guide).

## 3. Tools overview

Applications:

- esmini	

  Play OpenSCENARIO file. Many options, e.g. view on screen, save images to file or just save log data for post processing.

  Example:

      ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc

- replayer	

  Replay recorded esmini scenarios. Main difference from esmini is the ability to freely move forward and backward in the scenario at various speeds.

  Example:

      ./bin/replayer --window 60 60 800 400 --file sim.dat

  See Use cases how to create recordings (`.dat` files) from esmini.

- odrviewer	

  Visualize and verify OpenDRIVE road networks. Draw road features, like reference line and lanes, on top of a 3D model (provided or generated). Optionally populate with random traffic that will randomly find its way through the road network.

  Example:

      ./bin/odrviewer --window 60 60 800 400 --odr ./resources/xodr/fabriksgatan.xodr

- odrplot	

  Simple 2D plot of OpenDRIVE road lanes with indicated road IDs, in a two step process.

  Prerequisites: Python + matplotlib

  Example:

      ./bin/odrplot ./resources/xodr/fabriksgatan.xodr (will create a track.csv file)

      python ./EnvironmentSimulator/Applications/odrplot/xodr.py track.csv

- plot_dat	

  Simple 2D plot of scenario data

  Prerequisites: Python + matplotlib

  Example:

      ./bin/esmini --headless --osc ./resources/xosc/acc-test.xosc --fixed_timestep 0.05 --record sim.dat (will create the .dat file)

      ./scripts/plot_dat.py sim.dat --param speed

- dat2csv	

  Convert esmini recording (.dat) file to standard .csv format

  Example:

      ./scripts/dat2csv sim.dat
 
  will create sim.csv.

- osi2csv.py	

  Convert OSI trace file (from esmini) to .csv format

  Example:

      ./scripts/osi2csv.py ./ground_truth.osi

  will create ground_truth.csv

  See [Save OSI data](https://esmini.github.io/#_save_osi_data) how to create OSI groundtruth trace (`.osi` file) from esmini.

- plot_csv	

  Simple 2D plot of scenario data, similar to plot_dat

  Prerequisites: Python + matplotlib

  Example:

      ./bin/esmini --headless --osc ./resources/xosc/acc-test.xosc --fixed_timestep 0.05 --osi_file sim.osi (will create an osi trace file)

      ./scripts/osi2csv.py sim.osi (convert to .csv)

      ./scripts/plot_csv.py sim.csv --param ax # will plot the x component of acceleration vector.

Shared libraries:

- esminiLib	

  High level API for running, controlling and monitoring scenarios

  See headerfile [esminiLib.hpp](https://github.com/esmini/esmini/tree/master/EnvironmentSimulator/Libraries/esminiLib/esminiLib.hpp) and [Hello World programming tutorial](https://esmini.github.io/#_hello_world_programming_tutorial)

- esminiRMLib	

  High level API for parsing and query road networks (only road manager)

  See headerfile [esminiRMLib.hpp](https://github.com/esmini/esmini/tree/master/EnvironmentSimulator/Libraries/esminiRMLib/esminiRMLib.hpp) and code example [rm-basic](https://github.com/esmini/esmini/tree/master/EnvironmentSimulator/code-examples/rm-basic)

## 4. Use cases

Here follows basic examples showing some, but not all, features in esmini and companion tools. It should give an idea of the possibilities and limitations. For a full list of features and functions, see [Command reference](https://esmini.github.io/#_command_reference).

To quickly see available launch options, simply run the corresponding application with no arguments, for example:

    ./bin/odrviewer

### 4.1. View a scenario

#### 4.1.1. Basic features

Specify a window and scenario file. Example:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc

Visualize trails from moving entities:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --trail_mode 3

Show entities as bounding boxes:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --bounding_boxes

#### 4.1.2. Camera control

...

#### 4.1.3. Some key shortcut commands

...

See [Command reference](https://esmini.github.io/#_command_reference) for a complete list of key shortcut commands.

#### 4.1.4. Road network visualization

Visualize OpenDRIVE road features:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --road_features on

If a 3D model representation of the road network is missing (i.e. empty or missing SceneGraphFile element of the [OpenSCENARIO RoadNetwork class](https://www.asam.net/static_downloads/ASAM_OpenSCENARIO_V1.1.1_Model_Documentation/modelDocumentation/content/RoadNetwork.html)), then esmini will generate a very simple model.

Example:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc

Add optional flat ground plane:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc --ground_plane

The generated model can be saved:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc --save_generated_model

Then look for generated_road.osgb in the current directory.

#### 4.1.5. Background color

...

#### 4.1.6. Anti-alias

...

### 4.2. Screenshots and video clips

...

### 4.3. Logging

esmini can produce log files in different formats and for different purposes, explained next.

#### 4.3.1. The basic text log file

By default esmini is creating a `log.txt` in the folder from which esmini is launched. In case of esminiLib it will end up in the folder that the application linking esminiLib was launched from.

The log.txt includes the same information normally seen in the terminal window (stdout).

To disable output to terminal:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc --disable_stdout

To disable creation of the logfile (`log.txt`):

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc --disable_log

Developer info: Define the symbol DEBUG_TRACE (either as compile flag or by uncomment [this code line](https://github.com/esmini/esmini/blob/73390cc2c1b8cbb8403950c905515e304c861b8c/EnvironmentSimulator/Modules/CommonMini/CommonMini.cpp#L34)) to log more details, like what code module and line number is the origin of the log entry.

#### 4.3.2. Scenario recording (.dat)

In addition esmini can save a `.dat` file which captures the state of all entities. This file can later be used either to replay (see [Replay scenario](https://esmini.github.io/#_replay_scenario)) the scenario or converted to `.csv` for further analysis, e.g. in Excel.

To create a recording with regular timesteps:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/slow-lead-vehicle.xosc --fixed_timestep 0.05 --record sim.dat

To convert the .dat file into .csv, do either of:

    ./bin/dat2csv sim.dat

or

    python ./scripts/dat2csv.py sim.dat

Only a subset of the .dat file information is extracted. To extract some more info, e.g. road coordinates, run:

    ./scripts/dat2csv --extended sim.dat

#### 4.3.3. CSV logger

To create a more complete csv logfile, compared to the content of the .dat file, activate the CSV_Logger:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --fixed_timestep 0.05 --csv_logger full_log.csv

full_log.csv will contain more detailed states for all scenario entities. To also include collision detection:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --fixed_timestep 0.05 --csv_logger full_log.csv --collision

All collisions (overlap) between entity bounding boxes will be registered in the `collision_ids` column of each entity. It will contain the IDs of any entities overlapping at given frame.

### 4.4. Replay scenario

Replay a scenario recording (.dat file):

    ./bin/replayer --window 60 60 800 400 --res_path ./resources --file sim.dat

The `--res_path` is a special path directive should normally point to esmini/resources folder, where it will look for the OpenDRIVE file, 3D models and model_ids table (model_ids.txt). It also works to add one or multiple --path <path> directives, like for esmini.

#### 4.4.1. Multiple scenarios in parallel

...

#### 4.4.2. Save merged .dat files

...

### 4.5. View road network

#### 4.5.1. Visualize OpenDRIVE geometry

...

#### 4.5.2. Evaluate OpenDRIVE connectivity

...

#### 4.5.3. Inspect OpenDRIVE geometry and road IDs

...

### 4.6. Plot scenario data

...

### 4.7. Save OSI data

esmini can provide OSI groundtruth data in three ways:

1. Send over UDP

2. API to fetch via function call from a custom application

3. Save to OSI trace file

Only trace file way is described here. To save OSI data, add argument `--osi_file [filename]`. The filename is optional. If omitted it will be named `ground_truth.osi`. Example:

    ./bin/esmini --window 60 60 800 400 --osc ./resources/xosc/cut-in.xosc --osi_file

will create `ground_truth.osi` in the current folder. The format is according to the OSI standard "Binary trace file", see OSI documentation [2.2.6 OSI trace files](https://opensimulationinterface.github.io/osi-documentation/index.html#_osi_trace_files).

esmini provides a script, osi2csv.py, that converts an OSI trace file into .csv format. The script can also serve as example how to parse and extract data from an OSI trace file:

    ./scripts/osi2csv.py ground_truth.osi

will create ground_truth.csv.
(if file type association is not setup, try: `python ./scripts/osi2csv.py ground_truth.osi`)

However the .csv file created with osi2csv will not contain all OSI information. To get a readable text file including the complete content of a OSI trace file you can make use of this Python script from the OSI project:

https://github.com/OpenSimulationInterface/open-simulation-interface/blob/master/format/osi2read.py

Use as following example:

    ../open-simulation-interface/format/osi2read.py --data ./ground_truth.osi --output ground_truth --type GroundTruth

it should create `ground_truth.txth` which is readable in a text editor.

## 5. Scenario features

### 5.1. Speed profile

(introduced in esmini v2.23.0)

The OpenSCENARIO [SpeedAction](https://www.asam.net/static_downloads/ASAM_OpenSCENARIO_V1.1.1_Model_Documentation/modelDocumentation/content/SpeedAction.html) will reach a specified speed in a way described by additional attributes, e.g. shape and duration. To achieve multiple speed target over time you would need to add multiple SpeedAction events to the scenario. Moreover, there is no way to explicitly control the jerk (acceleration/deceleration rates).

However with the SpeedProfileAction (introduced in OpenSCENARIO v1.2) you can specify a series of speed targets over time, in one action. Optionally you can also specify dynamic constraints for jerk (gradually changing acceleration and deceleration), acceleration and speed.

If you run the example scenario [speed-profile.xosc](https://github.com/esmini/esmini/blob/master/resources/xosc/speed-profile.xosc) as follows:

    ./bin/esmini.exe --window 60 60 800 400 --osc ./resources/xosc/speed-profile.xosc --fixed_timestep 0.01 --record sim.dat

    ./scripts/plot_dat.py sim.dat --param speed

Tip: For quick experiments, skip the visualization and bring the plot asap by replacing the two commands with:

    ./bin/esmini.exe --headless --osc ./resources/xosc/speed-profile.xosc --fixed_timestep 0.01 --record sim.dat;./scripts/plot_dat.py sim.dat --param speed

The scenario includes two cars with identical speed profiles with one exception: The white Car1 use activate dynamic constraints by setting FollowingMode="follow" while the red Car2 will apply constant acceleration (linear interpolation) between speed targets by setting FollowingMode="position".

The action for white car:

    <SpeedProfileAction followingMode="follow">
        <DynamicConstraints
            maxAcceleration = "5.0"
            maxDeceleration = "10.0"
            maxAccelerationRate = "4.0"
            maxDecelerationRate = "3.0"
            maxSpeed = "50"
        />
        <SpeedProfileEntry time="0.0" speed="0.0"/>
        <SpeedProfileEntry time="4.0" speed="10.0"/>
        <SpeedProfileEntry time="4.0" speed="4.0"/>
        <SpeedProfileEntry time="2.0" speed="8.0"/>
    </SpeedProfileAction>

The time values are relative each other and start of the action. In this case the action is triggered at simulation time = 2 seconds. Initial speed for both cars is 0. First entry has therefor no effect since it applies speed = 0 at time = 2 (2 + 0). After additional 4 seconds (sim time = 6s) the speed target is 10 m/s. At sim time 10s the speed target is 4 m/s and finally after 2 more seconds the final speed target value is 8.0 m/s.

The "follow" mode deserves some additional explanation. As shown in the figure, it start and ends with zero acceleration. Then is basically will try to match the acceleration "lines" but cutting the corners according to acceleration and deceleration rate constraints. This way the intermediate speed values will not always be reached. However, the final speed value will be reached.

If the target speed or accelerations can’t be reached with given constraints the action will revert to linear mode (FollowingMode="position") for the remainder of the profile. This "failure" is logged.

Another approach would be to try to perform a best effort, but that would require additional input to decide whether to prioritize reaching specified speed targets or respect time stamps…​

Note: The implementation of this feature is preliminary and experimental. Behavior and details might change.

Let’s manipulate the scenario in different ways to illustrate some special cases of the speed-profile feature.

#### 5.1.1. Special case: Single entry

(Special case implementation introduced in esmini v2.23.1)

Compared to SpeedAction, the SpeedProfileAction offers more tools in terms of dynamic constraints. Hence it can be actually be useful also for single entry, i.e. reach a single target speed.

The implementation differs for the single entry case. Target speed will be reached if constraints allows for it. If not, the speed will still be reached, but later than specified.

There are three sub cases:

##### 1. Speed can be reached within time

The speed profile will contain three phases: Jerk, constant acceleration, jerk.

Example:

Replace the four entries in speed-profile.xosc with the following ones:

    <SpeedProfileEntry time="0.0" speed="0.0"/>
    <SpeedProfileEntry time="4.0" speed="10.0"/>

Initial positive jerk will be applied until necessary acceleration is reached. Keep constant acceleration (linear segment in the speed profile) until negative jerk needs to be applied in order to reach target speed on time and at zero acceleration.

##### 2. Speed can't be reached in time due to acceleration constraints

This speed profile will also contain three phases: Jerk, constant acceleration, jerk.

Example:

Replace the four entries in speed-profile.xosc with the following ones:

    <SpeedProfileEntry time="0.0" speed="0.0"/>
    <SpeedProfileEntry time="3.0" speed="10.0"/>

Initial positive jerk will be applied until maximum acceleration is reached (or maximum deceleration). Keep constant acceleration (linear segment in the speed profile) until negative jerk needs to be applied in order to reach target speed at zero acceleration. Due to the acceleration limitation there will be a delay as well. The log file will include something like:

    SpeedProfile: Constraining acceleration from 5.86 to 5.00
    SpeedProfile: Extend 0.46 s

##### 3. Speed can't be reached in time due to jerk constraints

This speed profile will contain only two jerk phases.

Example:

Keep entries from last case, but change jerk settings as follows:

    maxAccelerationRate="3.0"
    maxDecelerationRate="2.0"

In this case the jerk settings are too weak to reach target speed in time. Not enough acceleration can be achieved in the given time window.

Positive jerk will be applied until negative jerk has to be applied in order to reach target speed at zero acceleration. Hence there is no room for a phase of constant acceleration. Due to the jerk limitation there will be a delay. The log file will include something like:

    SpeedProfile: Can't reach target speed 10.00 on target time 3.00s with given jerk constraints, extend to 4.08s

#### 5.1.2. What if current speed differ from the first entry?

Replace the four entries with the following ones:

    <SpeedProfileEntry time="0.0" speed="3.0"/>
    <SpeedProfileEntry time="4.0" speed="10.0"/>

What we see here is that for linear mode (FollowingMode="position") the speed of the first entry will apply immediately regardless of the current speed at the time of the action being triggered. For constrained mode (FollowingMode="follow") we see that the initial speed value (3.0) is overridden by the current speed (0.0). From there it will strive for the second entry, obeying the constraints.

The overall idea with the "follow" mode is to maintain continuity in the speed profile, up to jerk degree.

#### 5.1.3. What if time is missing in entry?

Replace any entries with the following ones:

    <SpeedProfileEntry speed="10.0"/>

Specified max acceleration will be applied until target speed is reached. Note: In the non-linear case and with multiple entries, the function will fail if the specified acceleration can’t be reached with given jerk constraints (maxAcceleration and maxDeceleration). Try to lower the maxAcceleration/deceleration in this case.

You can also combine entries with and without time constraint, like in following example:

    <SpeedProfileEntry speed="10.0"/>
    <SpeedProfileEntry time="3.0" speed="15.0"/>

Car will accelerate until speed 10 m/s is reached, then spend 3 seconds to reach 15 m/s.

#### 5.1.4. Initial acceleration taken into account

(from release v2.23.2)

What if the acceleration is not zero when the SpeedProfileAction is started, for example interrupting an ongoing SpeedAction in Follow mode?

To maintain a continuous acceleration profile the action will use current acceleration as initial value. The standard states that the acceleration is expected to be zero at start and end of the action. The esmini interpretation is that the CHANGE is zero at start while the ACTUAL value is zero at end (since the action can only control acceleration while being active, not before).

Example: Once again starting from [speed-profile.xosc](https://github.com/esmini/esmini/blob/master/resources/xosc/speed-profile.xosc), instead of setting an instant initial speed make it ramp up from 0 to 5 m/s over a duration of 4 seconds by tweaking the initial speed actions, for both entities, as below:

    <SpeedActionDynamics dynamicsShape="linear" value="5.0" dynamicsDimension="time"/>
    <SpeedActionTarget>
        <AbsoluteTargetSpeed value="4.0"/>
    </SpeedActionTarget>

The initial speed action will apply constant acceleration until time = 2.0 seconds, when the SpeedProfileAction is triggered. While the linear profile will jump to 0 m/s (as specified in first entry) the follow mode profile will just apply necessary jerk to reach target acceleration with respect to following entries.

Initial acceleration is also respected for the special case of a single entry, for example:

    <SpeedProfileEntry time="3.0" speed="10.0"/>

#### 5.1.5. Sharp brake-to-stop profile

To skip jerk phase, e.g. as in emergency brake with an abrupt stop, just set AccelerationRate to a large number.

Example: Once again starting from [speed-profile.xosc](https://github.com/esmini/esmini/blob/master/resources/xosc/speed-profile.xosc), change speed in the Init speed actions to 10.0 and replace the speed profile actions as below:

    <SpeedProfileAction followingMode="follow">
        <DynamicConstraints
            maxAcceleration = "5.0"
            maxDeceleration = "10.0"
            maxAccelerationRate = "1E10"
            maxDecelerationRate = "3.0"
            maxSpeed = "50"
        />
        <SpeedProfileEntry time="0.0" speed="10.0"/>
        <SpeedProfileEntry time="4.0" speed="0.0"/>
    </SpeedProfileAction>

Note: A drawback is that the setting will affect any acceleration phase in the complete profile. In other words, a limitation is that entries can't have individual settings. In the example above it's not problem since the first jerk phase is a deceleration while the second is an acceleration. If different rate values of same type are needed, it can be achieved by defining multiple SpeedProfile actions in a sequence, with individual performance settings.

#### 5.1.6. More info

To get more understanding of the implementation, see a few slides [here](https://drive.google.com/file/d/1DmjVHftcsbU71Ce_GASZ6IArcPA6teNF/view?usp=sharing).

### 5.2. Road signs

(framework updated in esmini v2.25.0)

#### 5.2.1. The system

Road signs are specified in the [OpenDRIVE](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4422&token=e590561f3c39aa2260e5442e29e93f6693d1cccd#top-016f925e-bfe2-481d-b603-da4524d7491f) road network description file. A road sign is identified by up to four parameters:

1. country code

2. type

3. subtype

4. value

Country code is a two letter word according to the [ISO 3166-1 alpha-2 system](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). Examples: Sweden = se, Germany = de.

...

#### 5.2.2. esmini sign catalogs

Instead of hard-coding road sign support esmini will lookup the [OSI code](https://opensimulationinterface.github.io/open-simulation-interface/structosi3_1_1TrafficSign_1_1MainSign_1_1Classification.html) from a separate sign definition file, which is unique for each country. Name convention for the file is: `country code` + "_traffic_signals.txt". Example: Swedish catalog is named "se_traffic_signals.txt".

...

#### 5.2.3. Sign 3D models

...

#### 5.2.4. Example

...

### 5.3. Expressions

From OpenSCENARIO v1.1 [expressions](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4908&token=ae9d9b44ab9257e817072a653b5d5e98ee0babf8#_expressions) including mathematical operations are supported in assignment of value to OpenSCENARIO [parameters](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4908&token=ae9d9b44ab9257e817072a653b5d5e98ee0babf8#_parameters) and XML element attributes. Examples:

...

### 5.4. Parameter distributions

Parameter values and distributions can be specified in a separate [Parameter value distribution file](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4908&token=ae9d9b44ab9257e817072a653b5d5e98ee0babf8#_parameter_value_distribution_file). This is a convenient way of running multiple variations, or parameter value permutations, of a single scenario.

Here’s an example: [cut-in_parameter_set.xosc](https://github.com/esmini/esmini/blob/master/resources/xosc/cut-in_parameter_set.xosc).

...

### 5.5. Trajectories

Using OpenSCENARIO [FollowTrajectoryAction](https://www.asam.net/static_downloads/ASAM_OpenSCENARIO_V1.2.0_Model_Documentation/modelDocumentation/content/FollowTrajectoryAction.html) you can define various types of trajectories for entities to follow.

esmini supports all three (as of OpenSCENARIO 1.2) shapes:

1. polyline

2. clothoid

3. nurbs

Here follows a few design choices for the polyline type that affect the behavior.

When FollowMode is `follow` esmini will:

1. Calculate heading based on direction of the line segments. However corners are interpolated in order to look better and avoid discontinuities.

2. Calculate speed based on current speed (when action is triggered) and then with constant acceleration per segment reach destination vertex on time (or earlier if distance is too short vs time). This approach results in a continuous speed profile.

When FollowMode is `position` esmini will:

1. For world coordinates, apply whatever heading is specified in the vertices (note that 0.0 is default). Lane and road coordinates will align to road direction as default.

2. For each segment, calculate constant speed needed to reach next vertex on time. This approach results in a discontinuous speed profile.

## 6. Controllers

### 6.1. Controller concept

OpenSCENARIO provides the controller concept as a way to outsource control the motion and appearance of scenario entities. For the OpenSCENARIO description of the controller concept, see [OpenSCENARIO User Guide](https://www.asam.net/index.php?eID=dumpFile&t=f&f=4908&token=ae9d9b44ab9257e817072a653b5d5e98ee0babf8#_controllers).

Controllers can be assigned to object of type **Vehicle or Pedestrian**. Once assigned, controllers are activated for a given domain (e.g longitudinal, lateral, Lighting, Animation) using the ActivateControllerAction. It’s also possible to activate immediately as part of the AssignControllerAction.

While the ActivateControllerAction is executing, the Controller assigned to that object will manage specified domain(s). Controllers may be **internal** (part of the simulator) or **external** (defined in another file).

Intended use cases for Controllers include:

- Specifying that a vehicle is controlled by the system under test.

- Defining smart actor behavior, where a controller takes intelligent decisions in response to the road network or other actors. Hence, controllers can be used, for example, to make agents in a scenario behave in a human-like way.

- Assigning a vehicle to direct human control.

The Controller element contains Properties, which can be used to specify controller behavior either directly or by a file reference.

Although OpenSCENARIO from v1.2 supports assignment of multiple controllers to an object, esmini is currently only supporting one controller to be assigned (and hence activated) to an object at the time.

### 6.2. Background and motivation

esmini version < 2.0 totally lacked support for controllers. Instead some similar functionality were implemented as part of different example-applications. For example, EgoSimulator provided interactive control of one vehicle. There was also an "external" mode which allowed for an external vehicle simulator to report current position for the typical Ego (VUT/SUT…​) vehicle.

First, this approach made the example code of simple applications complex. Secondly, it limited the use cases of esmini since functionality was tightly embedded in the applications.

Controllers provides a much more flexible way of adding functionality to esmini, in a way harmonizing with the standard (OpenSCENARIO 1.X). A side effect of this "outsourcing" of functionality is that the former demo applications could be reduced to a minimum both in number and size.

### 6.3. Brief on implementation

Controllers was introduced in esmini v2.0. Briefly it works as follows:

There is a collection of embedded controllers coming with esmini. Each controller inherit from the base class Controller (Controller.h/cpp). In order for esmini to be aware of the existence of a controller it has to be registered. This is done through the ScenarioReader method [RegisterController](https://github.com/esmini/esmini/blob/3d1abcd6b3e3855707dc424f7c25477bbf136078/EnvironmentSimulator/Modules/ScenarioEngine/SourceFiles/ScenarioReader.hpp#L132). It will put the controller into a collection to have available when the scenario is being parsed. So all controllers need to be registered prior to loading the scenario.

A controller is registered with the following information:

1. Its static name which is used as identifier.

2. A pointer to a function instantiating the controller.

This architecture makes it possible for an external module to create a controller and registering it without modifying any of esmini modules. In that way it is a semi-plugin concept, you can say.

Note: Even though ScenarioReader have a helper function for registering all the embedded controllers the RegisterController can be called from any module directly, at any time prior to scenario initialization.

esmini catalog framework supports controllers as well, so controllers can be defined in catalogs as presets, just like vehicles and routes for example.

### 6.4. How it works for the user

...

### 6.5. The ghost concept

...

### 6.6. esmini embedded controllers

Below is a listing of some of the available controllers in esmini. Note that only DefaultController is related to the OpenSCENARIO standard. The other ones are esmini-specific and will not work in other tools (so far there is no standard plugin-architecture for controllers to enable moving between tools). For updated and complete definition of controllers and their parameters, see [ControllerCatalog.xosc](https://github.com/esmini/esmini/blob/master/resources/xosc/Catalogs/Controllers/ControllerCatalog.xosc).

...

## 7. OpenSceneGraph and 3D models

...

## 8. Support / Q&A

...

## 9. Build guide

### 9.1. Build configurations in Visual Studio and Visual Studio Code

...

### 9.2. Build configurations from command line

CMake tool is used to create standard make configurations. A few example "create…​" batch scripts are supplied (in `scripts` folder) as examples how to generate desired build setup from command line.

...

### 9.3. External dependencies

esmini is designed to link all dependencies statically. Main reason is to have a all-inclusive library for easy integration either as a shared library/DLL (e.g. plugin in Unity, or S-function in Simulink) or statically linked into a native application.

Note: Nothing stops you from going with all dynamic linking, it’s just that provided build scripts are not prepared for it.

CMake scripts will download several pre-compiled 3rd party packages and **3D model resource files**.

...

### 9.4. Additional platform dependencies

Linux Ubuntu 18.04

    sudo apt install build-essential gdb ninja-build git pkg-config libgl1-mesa-dev libpthread-stubs0-dev libjpeg-dev libxml2-dev libpng-dev libtiff5-dev libgdal-dev libpoppler-dev libdcmtk-dev libgstreamer1.0-dev libgtk2.0-dev libcairo2-dev libpoppler-glib-dev libxrandr-dev libxinerama-dev curl cmake

Also, g++ version >= 5 is needed for c++14 code support.

Windows and Mac: Install the cmake application

### 9.5. Run with Linux and visual studio code

...

### 9.6. Debug with Linux and visual studio code

...

### 9.7. Dynamic protobuf linking

When linking esmini with software already dependent on Google protobuf there might be need for dynamic linking of shared protobuf library. This can be achieved by defining cmake symbol DYN_PROTOBUF as following example:

    cmake .. -D DYN_PROTOBUF=True

Then build as usual. It will link with protobuf shared library instead of linking with a static library.

When running esmini protobuf shared library need to be available. Set LD_LIBRARY_PATH to point to the folder where the library is, example:

    export LD_LIBRARY_PATH=./externals/OSI/linux/lib-dyn

Note:

The dynamic versions of protobuf were added Aug 31 2021. So you might need to update the OSI library package. Get the latest from following links:

- [OSI Windows](https://dl.dropboxusercontent.com/s/an58ckp2qfx5069/osi_v10.7z?dl=0)

- [OSI Linux](https://dl.dropboxusercontent.com/s/kwtdg0c1c8pawa1/osi_linux.7z?dl=0)

- [OSI Mac](https://dl.dropboxusercontent.com/s/m62v19gp0m73dte/osi_mac.7z?dl=0)

### 9.8. Slim esmini - customize configration

The external dependencies OSG, OSI and SUMO are optional. Also the unit test suite is optional, in effect making the dependecy to googletest framework optional as well. All these options are simply controlled by the following cmake options:

- USE_OSG

- USE_OSI

- USE_SUMO

- USE_GTEST

So, for example, to cut dependency to OSG and SUMO, run:

    cmake .. -D USE_OSG=False -D USE_SUMO=False

To disable OSG, SUMO, OSI and googletest, run:

    cmake .. -D USE_OSG=False -D USE_SUMO=False -D USE_OSI=False -D USE_GTEST=False

All options are enabled/True as default.

Note:

Disabling an external dependency will disable corresponding functionality. So, for example, disabling OSI means that no OSI data can be created by esmini. Disabling OSG means that esmini can’t visualize the scenario. However it can still run the scenario and create a .dat file, which can be played and visualized later in another esmini build in which OSG is enabled (even on another platform).

### 9.9. MSYS2 / MinGW-w64 support

...

### 9.10. Build esmini project

First generate build configuration (see above)

Then it should work on all platform to build using cmake as follows:

    cmake --build . --config Release --target install

Or you can go with platform specific ways of building:

#### Windows/Visual Studio

...

#### macOS

...

#### Linux

Once `cmake ..` has created the build configuration, of course you can build by calling the gnu `make` applciation directly instead of going via `cmake --build` as described above.

    cd build
    make -j4 install

This will build all projects, in four parallel jobs, and copy the binaries into a dedicated folder found by the demo batch scripts.

### 9.11. CentOS 7 (Linux)

...

## 10. Command reference





























