# Python Environment

- [Python Environment](#python-environment)
  - [设置默认 python 版本](#设置默认-python-版本)

## 设置默认 python 版本

Ubuntu:

- 假设环境中安装了 python3.4 与 python3.6 

- 首先, 设置 `update-alternatives`

      sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.4 1
      sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2

- 然后, 选择默认 python 版本

      sudo update-alternatives --config python
  
  或

      sudo update-alternatives  --set python /usr/bin/python3.6
