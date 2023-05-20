# [Quick start package installation](https://carla.readthedocs.io/en/0.9.14/start_quickstart/)

- [Quick start package installation](#quick-start-package-installation)
  - [Before you begin](#before-you-begin)
  - [CARLA installation](#carla-installation)
    - [A. Debian CARLA installation](#a-debian-carla-installation)
    - [B. Package installation](#b-package-installation)
    - [Import additional assets](#import-additional-assets)
  - [Install client library](#install-client-library)
    - [CARLA versions prior to 0.9.12](#carla-versions-prior-to-0912)
    - [CARLA 0.9.12+](#carla-0912)
      - [A. .egg files](#a-egg-files)
      - [B. .whl files](#b-whl-files)
      - [C. Downloadable Python package](#c-downloadable-python-package)
  - [Running CARLA](#running-carla)
    - [Command-line options](#command-line-options)
  - [Updating CARLA](#updating-carla)
  - [Follow-up](#follow-up)

This guide shows how to download and install the packaged version of CARLA. The package includes the CARLA server and two options for the client library. There are additional assets that can be downloaded and imported into the package. Advanced customization and development options that require use of the Unreal Engine editor are not available but these can be accessed by using the build version of CARLA for either Windows or Linux.

## Before you begin

- Pip. Some installation methods of the CARLA client library require pip or pip3 (depending on your Python version) version 20.3 or higher. To check your pip version:

       # For Python 3
       pip3 -V

       # For Python 2
       pip -V

  If you need to upgrade:

      # For Python 3
      pip3 install --upgrade pip

      # For Python 2
      pip install --upgrade pip

- Two TCP ports and good internet connection. 2000 and 2001 by default. Make sure that these ports are not blocked by firewalls or any other applications.

- Other requirements. CARLA requires some Python dependencies. Install the dependencies according to your operating system:

  Windows:

      pip3 install --user pygame numpy

  Linux:

      pip install --user pygame numpy &&
      pip3 install --user pygame numpy

## CARLA installation

### A. Debian CARLA installation

...

### B. Package installation

The package is a compressed file named CARLA_version.number. Download and extract the release file. It contains a precompiled version of the simulator, the Python API module and some scripts to be used as examples.

### Import additional assets

...

## Install client library

### CARLA versions prior to 0.9.12

...

### CARLA 0.9.12+

There are several options available to install and use the CARLA client library:

- .egg file
- .whl file
- Downloadable Python package

#### A. .egg files

...

#### B. .whl files

CARLA provides `.whl` files for different Python versions. You will need to install the `.whl` file. The `.whl` file is found in `PythonAPI/carla/dist/`. There is one file per supported Python version, indicated by the file name (e.g., carla-0.9.12-cp36-cp36m-manylinux_2_27_x86_64.whl indicates Python 3.6).

It is recommended to install the CARLA client library in a virtual environment to avoid conflicts when working with multiple versions.

To install the CARLA client library, run the following command, choosing the file appropriate to your desired Python version. You will need pip/pip3 version 20.3 or above. See the [Before you begin](https://carla.readthedocs.io/en/0.9.14/start_quickstart/#before-you-begin) section for how to check the version and upgrade pip/pip3:

    # Python 3
    pip3 install <wheel-file-name>.whl

    # Python 2
    pip install <wheel-file-name>.whl

If you previously installed the client library, you should [uninstall](https://carla.readthedocs.io/en/0.9.14/build_faq/#how-do-i-uninstall-the-carla-client-library) the old one before installing the new one.

#### C. Downloadable Python package

...

## Running CARLA

The method to start a CARLA server depends on the installation method you used and your operating system:

- Linux package installation:

      cd path/to/carla/root

      ./CarlaUE4.sh

A window containing a view over the city will pop up. This is the spectator view. To fly around the city use the mouse and `WASD` keys, holding down the right mouse button to control the direction.

This is the server simulator which is now running and waiting for a client to connect and interact with the world. You can try some of the example scripts to spawn life into the city and drive a car:

    # Terminal A 
    cd PythonAPI\examples

    python3 -m pip install -r requirements.txt # Support for Python2 is provided in the CARLA release packages

    python3 generate_traffic.py  

    # Terminal B
    cd PythonAPI\examples

    python3 manual_control.py 

### Command-line options

There are some configuration options available when launching CARLA and they can be used as follows:

    ./CarlaUE4.sh -carla-rpc-port=3000

- `-carla-rpc-port=N` Listen for client connections at port `N`. Streaming port is set to `N+1` by default.

- `-carla-streaming-port=N` Specify the port for sensor data streaming. Use `0` to get a random unused port. The second port will be automatically set to `N+1`.

- `-quality-level={Low,Epic}` Change graphics quality level. Find out more in [rendering options](https://carla.readthedocs.io/en/0.9.14/adv_rendering_options/).

- [List of Unreal Engine 4 command-line arguments](https://docs.unrealengine.com/en-US/Programming/Basics/CommandLineArguments). There are a lot of options provided by Unreal Engine however not all of these are available in CARLA.

The script `PythonAPI/util/config.py` provides more configuration options and should be run when the server has been started:

    ./config.py --no-rendering      # Disable rendering
    ./config.py --map Town05        # Change map
    ./config.py --weather ClearNoon # Change weather

    ./config.py --help # Check all the available configuration options

## Updating CARLA

...

## Follow-up

...
