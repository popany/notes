# vscode with c++

- [vscode with c++](#vscode-with-c)
  - [Debug](#debug)
    - [References](#references)
    - [vscode in windows + gdb in WSL docker container](#vscode-in-windows--gdb-in-wsl-docker-container)
      - [Debug coredump](#debug-coredump)
      - [Attach to process](#attach-to-process)

## Debug

### References

[windows系统vscode远程调试mysql](http://blog.itpub.net/11566490/viewspace-2670551/)

[vscode如何使用gdb调试](https://www.php.cn/tool/vscode/442575.html)

[Using C++ and WSL in VS Code](https://code.visualstudio.com/docs/cpp/config-wsl)

[Configuring C/C++ debugging](https://code.visualstudio.com/docs/cpp/launch-json-reference)

[Debug C++ in Visual Studio Code](https://code.visualstudio.com/docs/cpp/cpp-debug)

[vscode-debug-specs](https://74th.github.io/vscode-debug-specs/cpp/)

[Is it possible to attach to a remote gdb target with vscode?](https://stackoverflow.com/questions/38089178/is-it-possible-to-attach-to-a-remote-gdb-target-with-vscode)

### vscode in windows + gdb in WSL docker container

- REMOTE EXPLORER
  - Containers
    - Attach to Container
      - EXTENTIONS
        - Install C/C++ IntelliSense, debugging, and code browsing.
      - Run
        - config launch.json

`lauch.json`

    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "(gdb) Launch",
                "type": "cppdbg",
                "request": "launch",
                "program": "${workspaceFolder}/build/src/hello",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${workspaceFolder}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ]
            }
        ]
    }

#### Debug coredump

`lauch.json`

    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "(gdb) Launch",
                "type": "cppdbg",
                "request": "launch",
                "program": "<PATH-TO-BINARY>",
                "args": [],
                "stopAtEntry": false,
                "cwd": "${workspaceFolder}",
                "environment": [],
                "externalConsole": false,
                "MIMode": "gdb",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ],
                "coreDumpPath": "<PATH-TO-CORE-DUMP>"
            }
        ]
    }

#### Attach to process

            {
                "name": "(gdb) Attach",
                "type": "cppdbg",
                "request": "attach",
                "program": "${workspaceFolder}/a.out",
                "processId": "${command:pickProcess}",
                "MIMode": "gdb",
                "setupCommands": [
                    {
                        "description": "Enable pretty-printing for gdb",
                        "text": "-enable-pretty-printing",
                        "ignoreFailures": true
                    }
                ]
            }
