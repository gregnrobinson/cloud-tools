## Ubuntu Dockerfile
Used for cloud development on an M1 Mac due to package limitations for arm64


### Base Docker Image

* [amd64/ubuntu:18.04](https://hub.docker.com/r/amd64/ubuntu/)


### Prerequisites

1. Install [Docker](https://www.docker.com/).


### Build

    docker build -t="dockerfile/ubuntu" https://github.com/gregnrobinson/dockerfile-cloud-development-amd64