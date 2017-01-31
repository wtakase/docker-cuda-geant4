Docker cuda geant4
=====

## Build
After buildng [wtakase/cuda:8.0-centos7](https://github.com/wtakase/docker-cuda) image,
```
git clone https://github.com/wtakase/docker-cuda-geant4
cd docker-cuda-geant4
docker build -t wtakase/cuda-geant4 .
```

## Launch

Assume you have 4 GPU devices:
```
docker run -d -v /path/to/some/where:/home --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia0 --device /dev/nvidia1 --device /dev/nvidia2 --device /dev/nvidia3 wtakase/cuda-geant4
```
