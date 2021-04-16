
# ----------------------
# Development Workspace
# ----------------------

# Pull base image.
FROM amd64/ubuntu:18.04

ARG REPO_URL
#ARG GCP_SA_CRED

# PREREQUISITES
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# INSTALL TERRAFORM
RUN \
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get install -y terraform

  
# INSTALL GCP SDK AND PASS CREDENTIAL FILE
RUN \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
  apt-get update -y && apt-get install google-cloud-sdk -y
  #gcloud auth activate-service-account ACCOUNT --key-file=$GCP_SA_CRED


# Add files.
# ADD root/.bashrc /root/.bashrc
# ADD root/.gitconfig /root/.gitconfig
# ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# IMPORT SSH KEY FOR GIT
RUN mkdir -p ~/.ssh
COPY ~/.ssh/id_rsa ~/.ssh/id_rsa
RUN echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

# Define working directory.
WORKDIR /root

# IMPORT SSH KEY FOR GIT
RUN git clone $REPO_URL

#ADD ~/arctiq/p-google-cicd-pipeline-work /root

# Define default command.
CMD ["/bin/bash"]