## Ubuntu Dockerfile
Used for cloud development on an M1 Mac due to package limitations for arm64


This repository contains **Dockerfile** of [Ubuntu](http://www.ubuntu.com/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/dockerfile/ubuntu/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).


### Base Docker Image

* [amd64/ubuntu:18.04](https://hub.docker.com/r/amd64/ubuntu/)


### Prerequisites

1. Install [Docker](https://www.docker.com/).


### Build

    docker build -t="dockerfile/ubuntu" https://github.com/gregnrobinson/dockerfile-cloud-development-amd64