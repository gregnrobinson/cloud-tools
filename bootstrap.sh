#!/bin/bash

_VAULT_VERSION=1.7.1
_CONSUL_VERSION=1.9.5
_PACKER_VERSION=1.7.2
_GO_VERSION=1.16.4
_YQ_VERSION=4.2.0

apt update

apt install -y \
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
  unzip \
  vim \
  nodejs \
  moreutils \
  jq \
  tcpdump \
  openresolv \
  openssh-server \
  sshfs \
  iputils-ping

# KUBECTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# PYTHON VIRTUAL ENVIRONMENT
pip3 install virtualenv

# YQ
wget https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq &&\
  chmod +x /usr/bin/yq

# VAULT
wget https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_amd64.zip && \
  unzip vault_${_VAULT_VERSION}_linux_amd64.zip && \
  mv vault /usr/local/bin && \
  rm vault_${_VAULT_VERSION}_linux_amd64.zip

# TF_SWITCH
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# CONSUL
wget https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_amd64.zip && \
  unzip consul_${_CONSUL_VERSION}_linux_amd64.zip && \
  mv consul /usr/local/bin && \
  rm consul_${_CONSUL_VERSION}_linux_amd64.zip

# PACKER
wget https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_amd64.zip && \
  unzip packer_${_PACKER_VERSION}_linux_amd64.zip && \
  mv packer /usr/local/bin && \
  rm packer_${_PACKER_VERSION}_linux_amd64.zip

# GOLANG
wget https://golang.org/dl/go${_GO_VERSION}.linux-amd64.tar.gz && \
  tar -xvzf go${_GO_VERSION}.linux-amd64.tar.gz && \
  mv go /usr/local/bin && \
  rm go${_GO_VERSION}.linux-amd64.tar.gz

# GCP CLI
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
  apt update -y && \
  apt install google-cloud-sdk -y

# AWS CLI
pip3 install awscli

# AZURE CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
  apt install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
  apt update -y && \
  apt install -y azure-cli

#sudo apt clean
#sudo apt autoremove -y
#sudo rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*