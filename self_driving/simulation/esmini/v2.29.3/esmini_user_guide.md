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












