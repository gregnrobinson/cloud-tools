
# ----------------------------------
# Cloud Development Container Build
# ----------------------------------

# PULL BASE IMAGE
FROM amd64/ubuntu:18.04

ARG REPO_URL
ARG PRE_SIGNED_DOWNLOAD_URL

WORKDIR /root

# DOWNLOAD SSH KEY USING PRE SIGNED TEMP URL
RUN apt-get install -y openssh-server

RUN eval "$(ssh-agent -s)" && \
    mkdir -p /root/.ssh && \
    wget -i "$PRE_SIGNED_DOWNLOAD_URL" -q -O - > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa && \
    ssh-add /root/.ssh/id_rsa
    
# DEPENDENCIES
RUN apt-get update && \
    apt-get install -y \
      git \
      openssh-server \
      libmysqlclient-dev \
      curl \
      wget \
      gnupg \
      lsb-core \
      software-properties-common \
      python \
      unzip

# INSTALL TERRAFORM
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install terraform
    
    
# INSTALL GCP CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y
    #gcloud auth activate-service-account ACCOUNT --key-file=$GCP_SA_CRED

# INSTALL AWS CLI
RUN apt-get install -y awscli

# INSTALL AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -y && \
    apt-get install -y azure-cli

# CLONE PROJECT REPO
#RUN git clone ${REPO_URL}

#ADD ~/arctiq/p-google-cicd-pipeline-work /root

# Define default command.
CMD ["/bin/bash"]