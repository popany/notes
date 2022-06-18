# conda

- [conda](#conda)
  - [install conda](#install-conda)
  - [cmd](#cmd)
    - [`conda create`](#conda-create)
    - [`conda install`](#conda-install)
  - [use conda-forge channel](#use-conda-forge-channel)
## install conda

    wget -P /tmp https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
    
    bash Anaconda3-2019.10-Linux-x86_64.sh

## cmd

### `conda create`

    conda create -n mypython3 python=3

or

    conda create --name spy3 python=3.8

### `conda install`

    conda install <pkg>=<version>

## use conda-forge channel

    conda install -c conda-forge xxxxx
