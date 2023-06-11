# CARLA

- [CARLA](#carla)
  - [CARLA Agents v.s. Traffic Manager](#carla-agents-vs-traffic-manager)

https://carla.org/

## CARLA Agents v.s. Traffic Manager

1. CARLA Agents: 代表自动驾驶系统(ADS)的实体, 负责控制车辆. 这些代理有一个内部决策模块, 决定如何在虚拟环境中导航以遵守交通规则、避免碰撞、执行任务等. CARLA提供了一些预制的代理, 例如基本代理(BasicAgent)和Roaming Agent, 用户还可以根据需要定制自己的代理.

2. Traffic Manager: 专门用于管理和控制模拟环境中的其他车辆行为的模块, 而不是直接控制目标车辆. 它主要负责生成合适的交通流以创造具有挑战性的场景, 并协调所有非目标车辆的动作, 使其遵守交通规则, 确保整个模拟环境正常运行. Traffic Manager可实现各种复杂场景的控制, 如拥堵、车流汇聚等. 
简言之, CARLA Agents是控制目标车辆的智能驾驶系统, 而Traffic Manager是用于管理模拟环境中其他车辆的行为.













