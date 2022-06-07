# vscode with python

- [vscode with python](#vscode-with-python)
  - [launch.json](#launchjson)
    - [set env variable](#set-env-variable)

## launch.json

### set env variable

    "env": {
        "LD_LIBRARY_PATH": "/path/to/lib:${env:LD_LIBRARY_PATH}"
    }

