# Client

- [Client](#client)
  - [Prerequest](#prerequest)
  - [config.py](#configpy)
  - [example scripts](#example-scripts)
  - [misc](#misc)

## Prerequest

    pip3 install --upgrade pip

    pip3 install /home/carla/carla/Dist/CARLA_Shipping_0.9.14/LinuxNoEditor/PythonAPI/carla/dist/carla-0.9.14-cp38-cp38-linux_x86_64.whl

## config.py

reference:

https://carla.readthedocs.io/en/0.9.14/start_quickstart/

    ./config.py --no-rendering      # Disable rendering
    ./config.py --map Town05        # Change map
    ./config.py --weather ClearNoon # Change weather

    ./config.py --help # Check all the available configuration options
  
## example scripts

    # Terminal A 
    cd PythonAPI\examples

    python3 -m pip install -r requirements.txt # Support for Python2 is provided in the CARLA release packages

    python3 generate_traffic.py  

    # Terminal B
    cd PythonAPI\examples

    python3 manual_control.py 

## misc

[First Steps](https://carla.readthedocs.io/en/0.9.14/tuto_first_steps/)

[Maps and navigation](https://carla.readthedocs.io/en/0.9.14/core_map/)

[Actors and blueprints](https://carla.readthedocs.io/en/0.9.14/core_actors/)

