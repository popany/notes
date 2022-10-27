# Launch and Run

- [Launch and Run](#launch-and-run)
  - [Doc](#doc)
  - [Practice](#practice)
    - [Build](#build)
    - [Start](#start)
    - [Access Web UI](#access-web-ui)
    - [Select Drive Mode and Map](#select-drive-mode-and-map)
    - [Replay Demo Record](#replay-demo-record)

## Doc

docs/howto/how_to_launch_and_run_apollo.md

## Practice

### Build

    ./apollo.sh clean --all
    ./apollo.sh build_opt_gpu

or

    ./apollo.sh clean --all
    ./apollo.sh build_dbg
    

### Start

    ./scripts/bootstrap.sh start

Note:

    ./scripts/bootstrap.sh start
        |- ./scripts/monitor.sh start
        |       |- nohup cyber_launch start /apollo/modules/monitor/launch/monitor.launch &
        |
        |./scripts/dreamview.sh start 

ps afx

    2171 pts/70   Sl     0:00  \_ /usr/bin/python3 /apollo/bazel-bin/cyber/tools/cyber_launch/cyber_launch.runfiles/apollo/cyber/tools/cyber_launch/cyber_launch.py start /apollo/modules/monitor/launch/monitor.launch
    2179 pts/70   Sl     0:40  |   \_ mainboard -d /apollo/modules/monitor/dag/monitor.dag -p monitor -s CYBER_DEFAULT
    2254 pts/70   Sl     0:00  \_ /usr/bin/python3 /apollo/bazel-bin/cyber/tools/cyber_launch/cyber_launch.runfiles/apollo/cyber/tools/cyber_launch/cyber_launch.py start /apollo/modules/dreamview/launch/dreamview.launch
    2275 pts/70   Sl     0:35  |   \_ /apollo/bazel-bin/modules/dreamview/dreamview --flagfile=/apollo/modules/common/data/global_flagfile.txt

### Access Web UI

http://localhost:8888

### Select Drive Mode and Map

From the dropdown box of Mode Setup, select "Mkz Standard Debug" mode. From the dropdown box of Map, select "Sunnyvale with Two Offices".

### Replay Demo Record

    (cd docs/demo_guide/; python3 record_helper.py demo_3.5.record)

    cyber_recorder play -f docs/demo_guide/demo_3.5.record -l

