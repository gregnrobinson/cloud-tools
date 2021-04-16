set -x

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
docker build -t cloud_dev/ubuntu --build-arg PRE_SIGNED_DOWNLOAD_URL=$PRE_SIGNED_DOWNLOAD_URL --build-arg REPO_URL="git@github.com:gregnrobinson/dockerfile-cloud-development-amd64.git" .

# CLEANUP
gsutil rm gs://${GCS_BUCKET}/${GCS_OBJECT}

