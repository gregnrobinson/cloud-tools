## Ubuntu AMD64 Dockerfile
Used as a cloud development image until M1 Mac has more libraries for their apple silicon chip.

- ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) `WARNING: If you plan on using the Dockerfile to build and push to the container registry ensure that you remove the section that copies an SSH key to the container.`

### Base Docker Image

* [amd64/ubuntu:18.04](https://hub.docker.com/r/amd64/ubuntu/)


### Prerequisites

1. Install [Docker](https://www.docker.com/).

2. Create a GCP service account that can upload and download storage objects.

3. Place the json credential file in the current directory.

### build.sh

    # ENV VARIABLES
    GCS_BUCKET="cloud-dev-greg-arctiq"
    GCS_OBJECT="id_rsa"
    SSH_KEY_PATH="/Users/gregrobinson/.ssh/id_rsa"
    GCP_SA_CRED="./*.json"
    
    # AUTHENTICATE WTH A SERVIC ACCOUNT
    gcloud auth activate-service-account --key-file $GCP_KEY_FILE
    
    # CREATE TEMP SIGNED URL AND UPLOAD KEY
    PRE_SIGNED_UPLOAD_URL="$(gsutil signurl -m PUT -d 1m -c application/octet-stream -u gs://${GCS_BUCKET}/${GCS_OBJECT} | grep -o "https://.*")"
    curl -X PUT -H 'Content-Type: application/octet-stream' --upload-file $SSH_KEY_PATH $PRE_SIGNED_UPLOAD_URL
    
    # CREATE TEMP SIGNED URL TO ALLOW DOWNLOADING
    PRE_SIGNED_DOWNLOAD_URL="$(gsutil signurl -d 1m $GCP_KEY_FILE gs://${GCS_BUCKET}/${GCS_OBJECT} | grep -o "https://.*")"
    
    # BUILD DOCKER IMAGE AND COPY
    docker build -t cloud_dev/ubuntu --build-arg PRE_SIGNED_DOWNLOAD_URL=$PRE_SIGNED_DOWNLOAD_URL --build-arg REPO_URL="git@github.com:gregnrobinson/   dockerfile-cloud-development-amd64.git" .
    
    # CLEANUP
    gsutil rm gs://${GCS_BUCKET}/${GCS_OBJECT}
    