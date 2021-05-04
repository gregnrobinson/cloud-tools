
# ----------------------------------
# Cloud Development Container Build
# ----------------------------------

# PULL BASE IMAGE
FROM amd64/ubuntu:18.04

ARG PRE_SIGNED_DOWNLOAD_URL
ARG TF_VERSION

WORKDIR /root

# DEPENDENCIES
RUN apt-get update && \
    apt-get install -y \
      git \
      libmysqlclient-dev \
      curl \
      wget \
      gnupg \
      lsb-core \
      software-properties-common \
      python3-pip \
      unzip

# INSTALL TERRAFORM
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_${TF_VERSION}_linux_amd64.zip

# INSTALL VAULT
RUN wget https://releases.hashicorp.com/vault/1.7.1/vault_1.7.1_linux_amd64.zip && \
    unzip vault_1.7.1_linux_amd64.zip && \
    mv vault /usr/local/bin && \
    rm vault_1.7.1_linux_amd64.zip

# INSTALL GCP CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y

# INSTALL AWS CLI
RUN pip3 install awscli

# INSTALL AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -y && \
    apt-get install -y azure-cli

# Define default command.
CMD ["/bin/bash"]
