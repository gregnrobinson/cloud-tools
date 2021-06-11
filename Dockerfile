
# ----------------------------------------
# AMD64 Cloud Development Container Build
# ----------------------------------------

# PULL BASE IMAGE
FROM amd64/ubuntu:20.04:latest

# PACKAGE VERSIONS
ARG _TF_VERSION=0.14.10
ARG _VAULT_VERSION=1.7.1
ARG _CONSUL_VERSION=1.9.5
ARG _PACKER_VERSION=1.7.2
ARG _GO_VERSION=1.16.4
ARG _YQ_VERSION=4.2.0

WORKDIR /root

# DEPENDENCIES
RUN apt-get update && \
    apt-get install -y \
      git \
      libssl-dev \
      libmysqlclient-dev \
      curl \
      wget \
      gnupg \
      lsb-core \
      software-properties-common \
      python3-dev \
      python3-pip \
      python \
      python-pip \
      unzip \
      vim \
      nodejs \
      moreutils \
      jq

RUN pip3 install virtualenv

RUN wget https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# INSTALL VAULT
RUN wget https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${_VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/local/bin && \
    rm vault_${_VAULT_VERSION}_linux_amd64.zip

# INSTALL TFSWITCH
RUN curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# INSTALL CONSUL
RUN wget https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul_${_CONSUL_VERSION}_linux_amd64.zip && \
    mv consul /usr/local/bin && \
    rm consul_${_CONSUL_VERSION}_linux_amd64.zip

# INSTALL PACKER
RUN wget https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${_PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin && \
    rm packer_${_PACKER_VERSION}_linux_amd64.zip

# INSTALL GOLANG
RUN wget https://golang.org/dl/go${_GO_VERSION}.linux-amd64.tar.gz && \
    tar -xvzf go${_GO_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local/bin && \
    rm go${_GO_VERSION}.linux-amd64.tar.gz

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

# DEFAULT SHELL
ENTRYPOINT ["/bin/bash"]
