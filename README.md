# Overview

cloud-tools is an all in one cloud development container. Aimed at saving time when it comes to installing the large breadth of cloud SDKs and other tools. There are also CloudBuild files in the source repo for building this image automatically in GCP or locally if you want to manage the image yourself. Packages with static version numbers are default values and can be replaced during the build using `--build-arg`.

![Build](https://github.com//gregnrobinson/cloud-tools/actions/workflows/build.yaml/badge.svg) [![Build / Release](https://github.com/gregnrobinson/cloud-tools/actions/workflows/release.yaml/badge.svg?branch=main)](https://github.com/gregnrobinson/cloud-tools/actions/workflows/release.yaml) ![Docker Pulls](https://img.shields.io/docker/pulls/gregnrobinson/cloud-tools)

- Pull image: `docker pull gregnrobinson/cloud-tools:latest`
- Run image: `docker run -ith cloud-tools gregnrobinson/cloud-tools:latest`

## Installed Packages

- AWS SDK : latest
- Azure SDK : latest
- GCP SDK : latest
- kubectl : latest
- Vault : 1.7.1
- Packer : 1.9.5
- Consul : 1.9.5
- Git : latest
- Python : latest
- Python3 : latest
- pip : latest
- pip3 : latest
- jq : latest
- yq : 4.2.0
- nodejs : latest
- golang : 1.16.4
- wget : latest
- curl : latest
- vim : latest
- [tfswitch](https://tfswitch.warrensbox.com/Quick-Start/)
  - Run `tfswitch` to select desired Terraform version...

## Integrated Setup - VSCode

If you use vscode and want to run the image directly within your terminal, install the [Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension and create a folder called `.devcontainer` within your home directory, or wherever the root folder of your workspace is.

```sh
~/.devcontainer/
└── devcontainer.json
```

Then, Create a file called `.devcontainer.json` and paste the following to the file.

```json
{
  "image": "gregnrobinson/cloud-tools:latest"
}
```

Navigate to the bottom left corner of your screen, click the green section and select `reopen in container`. Now your running the container as the integrated terminal for the entire workspace. Your workspace is mounted to the container file system.

## Build locally using Docker

If you want to build the image locally, Run the following command at the root of the project directory. You can provide the `--build-arg` tag to change the version on any of the following packages. I will look at adding more like this, but it's mostly the HashiCorp products you want control over. The difference between 0.14 and 0.15 can be catastrophic.

|Package|Variable Name|Default|
|---|---|-----|
|Vault|_VAULT_VERSION|1.7.1|
|Packer|_PACKER_VERSION|1.9.5|
|Consul|_CONSUL_VERSION|1.9.5|
|Yq|_YQ_VERSION|4.2.0|
|Go|_GO_VERSION|1.64.4|

From the root of the repository run the following commands:

```bash
docker build --tag cloud-tools --build-arg "_VAULT_VERSION=1.7.0" .
docker run -v $(pwd):/root -i -t cloud-tools
```
