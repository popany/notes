# jupyter

- [jupyter](#jupyter)
  - [Jupyter Notebook Extensions](#jupyter-notebook-extensions)
    - [Install two packages from conda-forge channel](#install-two-packages-from-conda-forge-channel)
  - [jupytext](#jupytext)
  - [HowTo](#howto)
    - [Run jupyter from docker container](#run-jupyter-from-docker-container)
  - [run one remote server](#run-one-remote-server)
  - [Practice](#practice)
    - [How to increase the cell width of the Jupyter Notebook in browser?](#how-to-increase-the-cell-width-of-the-jupyter-notebook-in-browser)

## Jupyter Notebook Extensions

[Jupyter Notebook extensions to enhance your efficiency](https://www.endtoend.ai/blog/jupyter-notebook-extensions-to-enhance-your-efficiency/)

### [Install two packages from conda-forge channel](https://www.endtoend.ai/blog/jupyter-notebook-extensions-to-enhance-your-efficiency/)

## [jupytext](https://github.com/mwouts/jupytext)

...

## HowTo

### Run jupyter from docker container

    jupyter notebook --ip=0.0.0.0 --port=8080 --allow-root .

## run one remote server

- on remote server

      jupyter notebook --no-browser --port=8086

- on local host

      ssh -N -L localhost:8087:localhost:8086 user@server.address

## Practice

### [How to increase the cell width of the Jupyter Notebook in browser?](https://www.sneppets.com/python/how-to-increase-the-cell-width-of-the-jupyter-notebook-in-browser/)

    from IPython.core.display import display, HTML
    display(HTML("<style>.container { width:100% !important; }</style>"))

