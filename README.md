
![Commits](https://img.shields.io/github/commits-since/gregnrobinson/cloud-tools/latest)

![pre-commit](https://img.shields.io/github/workflow/status/gregnrobinson/cloud-tools/pre-commit?label=pre-commit) ![Build](https://img.shields.io/github/workflow/status/gregnrobinson/cloud-tools/ci-cloud-tools/main)  [![Codacy Badge](https://app.codacy.com/project/badge/Grade/825037ee15d748e19a3264317690ecbb)](https://www.codacy.com/gh/gregnrobinson/cloud-tools/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=gregnrobinson/cloud-tools&amp;utm_campaign=Badge_Grade)

# Overview

*cloud-tools* is an all in one cloud development container. With Multi arch support, you can freely run this on M1 (arm64) and x86 (amd64) chips without any performance hits. Packages with static version numbers are default values and can be replaced during the build using `--build-arg`.

- Pull image: `docker pull gregnrobinson/cloud-tools:latest`
- Run image:  `docker run -it gregnrobinson/cloud-tools:latest bash`

## Installed Packages

- AWS SDK : latest
- Azure SDK : latest
- GCP SDK : latest
- kubectl : latest
- Helm : latest
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
# for example...
~/.devcontainer/
```

Copy the files from the `.devcontainer` folder at the root of this repo to the `.devcontainer` folder on your local under your vscode workspace.

Modify the `./config/.bashrc` file environment variables to match your own environment.

Snippet from `./config/.bashrc` template...

```sh
# Any files in the config directory are mounted to /root home directory.

git config --global user.email 'user@example.com' && git config --global user.name 'Jane Doe'

# CLOUD CREDENTIALS CONFIG
export AWS_ACCESS_KEY_ID=<YOUR_AWS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_KEY>
export AWS_DEFAULT_REGION=ca-central-1
export GCP_SA_NAME="sa@<project_id>.iam.gserviceaccount.com"
# Put the json key file in the ./config directory.
export GOOGLE_APPLICATION_CREDENTIALS="/root/<key_file_name>"

gcloud auth activate-service-account $GCP_SA_NAME --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

After that, navigate to the bottom left corner of your screen, select the blue box in the bottom left corner and select `reopen in container`. Now your running the container as the integrated terminal for the entire workspace. Your workspace is mounted to the container file system.

The `./config` folder is mounted bidirectionally to the home directory (/root) of the container. Any files added or removed from the config directory will reflect in both in vscode and in the target container. This makes it easy to make changes to the environment configiration of a running container without a restart or rebuild.

## Build locally using Docker

If you want to build the image locally, Run the following command at the root of the project directory. You can provide the `--build-arg` tag to change the version on any of the following packages. I will look at adding more like this, but it's mostly the HashiCorp products you want control over. The difference between 0.14 and 0.15 can be catastrophic.

```dockerfile
# Customizable Package Versions
ARG _VAULT_VERSION=1.9.2
ARG _CONSUL_VERSION=1.10.4
ARG _PACKER_VERSION=1.7.8
ARG _GO_VERSION=1.17.5
ARG _YQ_VERSION=4.16.2
ARG _TF_SWITCH_VERSION=0.13.1201
```

From the root of the repository run the following commands:

```bash
docker build --tag cloud-tools --build-arg "_VAULT_VERSION=1.7.0" .
docker run -v $(pwd):/root -i -t cloud-tools
```
