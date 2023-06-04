# Examples

- [Examples](#examples)
  - [Prerequest](#prerequest)
  - [config.py](#configpy)
  - [generate\_traffic.py](#generate_trafficpy)
  - [manual\_control.py](#manual_controlpy)
  - [misc](#misc)

## Prerequest

    pip3 install --upgrade pip

    pip3 install /home/carla/carla/Dist/CARLA_Shipping_0.9.14/LinuxNoEditor/PythonAPI/carla/dist/carla-0.9.14-cp38-cp38-linux_x86_64.whl

    python3 -m pip install -r /home/carla/carla/Dist/CARLA_Shipping_0.9.14/LinuxNoEditor/PythonAPI/examples/requirements.txt
    
    apt install fontconfig

## config.py

reference:

https://carla.readthedocs.io/en/0.9.14/start_quickstart/

    ./config.py --no-rendering      # Disable rendering
    ./config.py --map Town05        # Change map
    ./config.py --weather ClearNoon # Change weather

    ./config.py --help # Check all the available configuration options
  
## generate_traffic.py  

## manual_control.py

Fix:

- /home/carla/.local/lib/python3.8/site-packages/pygame/sysfont.py:223: UserWarning: 'fc-list' is missing, system fonts cannot be loaded on your platform

      apt install fontconfig

## misc

[First Steps](https://carla.readthedocs.io/en/0.9.14/tuto_first_steps/)

[Maps and navigation](https://carla.readthedocs.io/en/0.9.14/core_map/)

[Actors and blueprints](https://carla.readthedocs.io/en/0.9.14/core_actors/)

https://carla.readthedocs.io/en/0.9.14/ts_traffic_simulation_overview/

https://carla.readthedocs.io/en/0.9.14/adv_traffic_manager/

https://carla.readthedocs.io/en/0.9.14/tuto_G_traffic_manager/

https://carla.readthedocs.io/en/0.9.14/tutorials/

https://carla.readthedocs.io/en/0.9.14/adv_agents/

https://carla.readthedocs.io/en/0.9.14/tuto_G_carsim_integration/

https://carla.readthedocs.io/en/0.9.14/foundations/

https://carla-scenariorunner.readthedocs.io/en/latest/

