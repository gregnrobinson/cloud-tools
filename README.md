## Overview
This project hosts all my custom docker files seperated by folder with a `Dockerfile`and `cloudbuild.yaml` file in each image folder so you can easily create your own image pipeline that versions your images and pushes them to a container registy. All inforamtion regarding the setuop of the pipeline is below.

![Cloud Build](https://storage.googleapis.com/${GOOGLE_CLOUD_PROJECT}-badges/builds/cloud-tools/branches/main.svg)

## Installed Packages

- AWS SDK : latest
- Azure SDK : latest
- GCP SDK : latest
- Terraform : 0.14.10
- Vault : latest
- Git : latest
- Python3 : latest
- jq : latest
- wget : latest
- curl : latest
- vim : latest

If you want to build the image locally run the following command
```sh
docker build -t cloud-tools:latest Dockerfile .
docker run -e "TF_VERSION=0.14.10" -e VAUlT_VERSION=0.14.10  cloud-tools .
``


```sh
gcloud services enable cloudbuild.googleapis.com --project ${PROJECT_ID}
gcloud services enable containerregistry.googleapis.com --project ${PROJECT_ID}
gcloud services enable storage.googleapis.com --project ${PROJECT_ID}
```

Assign the following permissions to the default service account for CloudBuild. The service account will be in the format `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`.

  - Cloud Build Service Account
  - Storage Admin

Modify the substitutions in the `./cloudbuild.yaml` file to match your requirements.

```sh
substitutions:
    _IMG: ubuntu-cloud-dev
    _IMG_DEST: gcr.io/arctiqteam-images/ubuntu-cloud-dev
```

## Link a git repository.

Either fork this repostiroy of create your own with the `./cloudbuild.yaml` file in it.

Go to the GCP ***console > Cloud Build > Triggers*** to connect your repository and add the trigger details matching expression. The default configuration is a push or merge to the main branch will trigger the pipeline.

## Run the pipeline.

Trigger the pipeline by updating the `Dockerfile` or `cloudbuild.yaml` in the source repository linked the trigger.

## Build Locally

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
