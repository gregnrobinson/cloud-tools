## Overview
This project hosts all my custom docker files seperated by folder with a `Dockerfile`and `cloudbuild.yaml` file in each image folder.

## Prerequisites

Start by enabling the clodubuild API so the default service account for CloudBuild is generated.

```sh
gcloud services enable cloudbuild.googleapis.com --project ${PROJECT_ID}
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
