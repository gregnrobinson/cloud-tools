## Overview
Used as a cloud development image until M1 Mac has more libraries for their apple silicon chip.

`WARNING: If you plan on using the Dockerfile to build and push to the container registry ensure that you remove the section that copies an SSH key to the container.`

### Base Docker Image

* [amd64/ubuntu:18.04](https://hub.docker.com/r/amd64/ubuntu/)

### Included Packages

* Terraform
* AWS CLI
* Azure CLI
* Google Cloud SDK

## Prerequisites

1. Install [Docker](https://www.docker.com/).

2. Create a GCP service account that can upload and download storage objects.

3. Place the json credential file in the current directory.

### build.sh

    # ENV VARIABLES
    TF_VERSION="0.14.10"
    GCS_BUCKET="cloud-dev-greg-arctiq"
    GCS_OBJECT="id_rsa"
    SSH_KEY_PATH="/Users/gregrobinson/.ssh/id_rsa"
    GCP_KEY_FILE="./*.json"
    
    # AUTHENTICATE WTH A SERVICE ACCOUNT
    gcloud auth activate-service-account --key-file $GCP_KEY_FILE
    
    # CREATE TEMP SIGNED URL AND UPLOAD KEY
    PRE_SIGNED_UPLOAD_URL="$(gsutil signurl -m PUT -d 1m -c application/octet-stream -u gs://${GCS_BUCKET}/${GCS_OBJECT} | grep -o "https://.*")"
    curl -X PUT -H 'Content-Type: application/octet-stream' --upload-file $SSH_KEY_PATH $PRE_SIGNED_UPLOAD_URL
    
    # CREATE TEMP SIGNED URL TO ALLOW DOWNLOADING
    PRE_SIGNED_DOWNLOAD_URL="$(gsutil signurl -d 5m $GCP_KEY_FILE gs://${GCS_BUCKET}/${GCS_OBJECT} | grep -o "https://.*")"
    
    # BUILD DOCKER IMAGE AND COPY
    docker build -t cloud_dev/ubuntu --build-arg TF_VERSION=$TF_VERSION --build-arg PRE_SIGNED_DOWNLOAD_URL=$PRE_SIGNED_DOWNLOAD_URL .
    
    # CLEANUP
    gsutil rm gs://${GCS_BUCKET}/${GCS_OBJECT}
    
## Usage

    ./build.sh
