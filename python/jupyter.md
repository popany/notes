# jupyter

- [jupyter](#jupyter)
  - [Jupyter Notebook Extensions](#jupyter-notebook-extensions)
    - [Install two packages from conda-forge channel](#install-two-packages-from-conda-forge-channel)
  - [HowTo](#howto)
    - [Run jupyter from docker container](#run-jupyter-from-docker-container)

## Jupyter Notebook Extensions

[Jupyter Notebook extensions to enhance your efficiency](https://www.endtoend.ai/blog/jupyter-notebook-extensions-to-enhance-your-efficiency/)

### [Install two packages from conda-forge channel](https://www.endtoend.ai/blog/jupyter-notebook-extensions-to-enhance-your-efficiency/)

## HowTo

### Run jupyter from docker container

    jupyter notebook --ip=0.0.0.0 --port=8080 --allow-root .

## run one remote server

- on remote server

      jupyter notebook --no-browser --port=8086

- on local host

      ssh -N -L localhost:8087:localhost:8086 user@server.address



