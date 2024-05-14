# Gaussian Splatting

- [Gaussian Splatting](#gaussian-splatting)
  - [资料整理](#资料整理)
  - [镜像](#镜像)
  - [运行](#运行)

## 资料整理

[Gaussian Splatting - wikipedia](https://en.wikipedia.org/wiki/Gaussian_splatting#cite_note-venturebeat-6)

[3D Gaussian Splatting for Real-Time Radiance Field Rendering](https://repo-sam.inria.fr/fungraph/3d-gaussian-splatting/)

[Street Gaussians for Modeling Dynamic Urban Scenes](https://zju3dv.github.io/street_gaussians/)

[Real-time Photorealistic Dynamic Scene Representation and Rendering with 4D Gaussian Splatting ICLR 2024](https://fudan-zvg.github.io/4d-gaussian-splatting/)

[4D Gaussian Splatting for Real-Time Dynamic Scene Rendering](https://guanjunwu.github.io/4dgs/)

[4D Gaussian Splatting: Towards Efficient Novel View Synthesis for Dynamic Scenes](https://arxiv.org/abs/2402.03307)

[DreamGaussian4D: Generative 4D Gaussian Splatting](https://jiawei-ren.github.io/projects/dreamgaussian4d/)

[GaussianFlow: Splatting Gaussian Dynamics for 4D Content Creation](https://arxiv.org/pdf/2403.12365v1)

[Gaussian-Flow: 4D Reconstruction with Dynamic 3D Gaussian Particle](https://nju-3dv.github.io/projects/Gaussian-Flow/)

[Align Your Gaussians: Text-to-4D with Dynamic 3D Gaussians and Composed Diffusion Models](https://arxiv.org/abs/2312.13763)

## 镜像

    docker run \
      --rm \
      --name test \
      -tid \
      -v $(pwd):$(pwd) \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -w $(pwd) \
      --network host \
      --gpus all \
      ubuntu:22.04 \
      bash

1. install cuda 11.8.0

       apt install build-essential dkms
       apt install freeglut3 freeglut3-dev libxi-dev libxmu-dev
       sh cuda_11.8.0_520.61.05_linux.run
       echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc
       echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
       source ~/.bashrc

2. clone git repo

       cd /opt
       apt install -y git
       git clone https://github.com/graphdeco-inria/gaussian-splatting --recursive

3. prepare python env

       # Install miniconda
       apt install -y wget
       mkdir -p ~/miniconda3
       wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
       bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
       rm -rf ~/miniconda3/miniconda.sh
       ~/miniconda3/condabin/conda init

       # exit and reenter container
       sed -i s'/- cudatoolkit=11.6//' /opt/gaussian-splatting/environment.yml
       conda env create --name gaussian --file /opt/gaussian-splatting/environment.yml
       echo "conda activate gaussian" >> ~/.bashrc

4. install colmap

       apt-get install \
           git \
           cmake \
           ninja-build \
           build-essential \
           libboost-program-options-dev \
           libboost-filesystem-dev \
           libboost-graph-dev \
           libboost-system-dev \
           libeigen3-dev \
           libflann-dev \
           libfreeimage-dev \
           libmetis-dev \
           libgoogle-glog-dev \
           libgtest-dev \
           libsqlite3-dev \
           libglew-dev \
           qtbase5-dev \
           libqt5opengl5-dev \
           libcgal-dev \
           libceres-dev

       cd /opt
       git clone https://github.com/colmap/colmap
       cd colmap
       mkdir build
       cd build
       cmake .. -DCMAKE_CUDA_ARCHITECTURES=86
       make -8 CXXFLAGS="-DBOOST_BIND_GLOBAL_PLACEHOLDERS"
       make install

       cp  /opt/colmap/build/src/colmap/exe/colmap /usr/local/bin

   注：查看 CUDA_ARCHITECTURES

       /usr/local/cuda/extras/demo_suite/deviceQuery

       ...
       CUDA Capability Major/Minor version number:    8.6
       ...

5. build SIBR_viewers

       apt install -y libglew-dev libassimp-dev libboost-all-dev libgtk-3-dev libopencv-dev libglfw3-dev libavdevice-dev libavcodec-dev libeigen3-dev libxxf86vm-dev libembree-dev

       cd /opt/gaussian-splatting/SIBR_viewers
       cmake -Bbuild . -DCMAKE_BUILD_TYPE=Release
       cmake --build build -j8 --target install

6. 保存镜像

       docker commit test gaussian_splatting:0.0.1

## 运行

    docker run \
      --rm \
      --name gaussian \
      -tid \
      -v $(pwd):$(pwd) \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      -w /opt/gaussian-splatting \
      --network host \
      --gpus all \
      gaussian_splatting:0.0.1 \
      bash


    ffmpeg -i gs-test.mp4 -qscale:v 1 -qmin 1 -vf fps=2 %04d.jpg

    export DISPLAY=:5

    python convert.py -s ../test

    python train.py -s ../test/
