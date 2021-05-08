# Overview
![Cloud Build](https://storage.googleapis.com/phronesis-310405-badges/builds/cloud-tools/branches/main.svg)

cloud-tools is an all in one cloud development container that aims to eliminate package installation whenever you might get a new job or new computer. Also, for the past few months, Apples new M1 chip is still lacking many of the neccesary libraries for tools used by developers and engineers. So at the moment I am going to be Using this container as my daily driver. 

## Installed Packages

- AWS SDK : latest
- Azure SDK : latest
- GCP SDK : latest
- Terraform : 0.14.10
- Vault : 1.7.1
- Packer : 1.9.5
- Consul : 1.9.5
- Git : latest
- Python3 : latest
- jq : latest
- wget : latest
- curl : latest
- vim : latest
- yq : 4.2.0

# Integrated Setup - VSCode
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
Navigate to the bottom left corner of your screen and select `reopen in container`. Now your running solely on the container in this repository.Your entire workspace structure is mounted automatically.
# Building Locally

If you want to build the image locally run the following command at the root of the project directory. You can provide the `--build-arg` tag to change the version on any of the following packages.
|Package|Variable Name|Default|
|---|---|-----|
|Terraform|_TERRAFORM_VERSION|0.14.10|
|Vault|_VAULT_VERSION|1.7.1|
|Packer|_PACKER_VERSION|1.9.5|
|Consul|_CONSUL_VERSION|1.9.5|
|Browsh|_BROWSH_VERSION|1.6.4|
|Yq|_YQ_VERSION|4.2.0|
||||

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

## Cloud Buid Local Builder

Within the root of the directory run the following to build the image.

```sh
gcloud components install cloud-build-local

SHORT_SHA=$(git rev-parse --short HEAD)

TF_VERSION="0.14.10"
VAULT_VERSION="1.7.1"

cloud-build-local --config=./ubuntu-cloud-dev/cloudbuild-local.yaml \
  --substitutions _SHORT_SHA=$SHORT_SHA \
  --substitutions _TF_VERSION=$TF_VERSION \
  --substitutions _VAULT_VERSION=$VAULT_VERSION \
  --dryrun=false --push .
```
