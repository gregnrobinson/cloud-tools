# Overview

cloud-tools is an all in one cloud development container. Aimed at saving time when it comes to installing the large breadth of cloud SDKs and other tools. There are also CloudBuild files in the source repo for building this image automatically in GCP or locally if you want to manage the image yourself. Packages with static version numbers are default values and can be replaced during the build using `--build-arg`.

![Cloud Build](https://storage.googleapis.com/phronesis-310405-badges/builds/cloud-tools/branches/main.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/gregnrobinson/cloud-tools)

## Installed Packages

- AWS SDK : latest
- Azure SDK : latest
- GCP SDK : latest
- Terraform : 0.14.10
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

## Integrated Setup - VSCode
If you use vscode and want to run the image directly within your terminal, install the [Remote Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension and create a folder called `.devcontainer` within your home directory, or wherever the root folder of your workspace is.
```
~/.devcontainer/
└── devcontainer.json
```
Then, Create a file called `.devcontainer.json` and paste the following to the file.
```
{
  "image": "gregnrobinson/cloud-tools:latest"
}
```
Navigate to the bottom left corner of your screen and select `reopen in container`. Now your running a Docker as the integrated terminal for the entire workspace. Your workspace is mounted to the container file system.

## Build locally using Docker.

If you want to build the image locally, Run the following command at the root of the project directory. You can provide the `--build-arg` tag to change the version on any of the following packages. I will look at adding more like this, but it's mostly the HashiCorp products you want control over. The difference between 0.14 and 0.15 is catastrophic. 

|Package|Variable Name|Default|
|---|---|-----|
|Terraform|_TERRAFORM_VERSION|0.14.10|
|Vault|_VAULT_VERSION|1.7.1|
|Packer|_PACKER_VERSION|1.9.5|
|Consul|_CONSUL_VERSION|1.9.5|
|Yq|_YQ_VERSION|4.2.0|
|Go|_GO_VERSION|1.64.4|

```sh
docker build --tag cloud-tools --build-arg "_TF_VERSION=0.15.3" .
docker run -v $(pwd):/root -i -t cloud-tools bash
```

# Build using CloudBuild

If automating this process is more what you want, first fork this repository and follow the steps below.
```sh
gcloud services enable cloudbuild.googleapis.com --project ${PROJECT_ID}
gcloud services enable storage.googleapis.com --project ${PROJECT_ID}
```

Modify the substitutions in the `./cloudbuild.yaml` file to match your requirements.
```sh
substitutions:
    _IMG_DEST: gcr.io/<REPO_NAME>/<IMAGE_NAME>
```
## Link your git repository.

Either fork this repostiroy of create your own with the `./cloudbuild.yaml` file in it.

Go to the GCP ***console > Cloud Build > Triggers*** to connect your repository and add the trigger details matching expression. The default configuration is a push or merge to the main branch will trigger the pipeline.

## Run the pipeline.

Trigger the pipeline by updating the `Dockerfile` in the source repository linked the trigger.

## Build Using Local Builder

Use the provided `cloudbuild_local.yaml` to perform a build task on the image the same way the pipeline would. This is useful for testing new changes before pushing a new version of the image.

*NOTE: Must have docker installed.*

```sh
gcloud components install cloud-build-local

cloud-build-local \
  --config=./cloudbuild_local.yaml \
  --dryrun=false --push .
```
