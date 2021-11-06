
# ----------------------------------------
#  MultiArch Container Build
# ----------------------------------------

# PULL BUILD IMAGE
FROM --platform=$BUILDPLATFORM golang:alpine AS build
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "${TARGETPLATFORM##*/}" > /target_arch

# PULL BASE 
FROM ubuntu:latest
COPY --from=build /target_arch /target_arch
COPY ./config/profile/bashrc /root/.bashrc

# PACKAGE VERSIONS
ARG DEBIAN_FRONTEND=noninteractive
ARG _VAULT_VERSION=1.8.5
ARG _CONSUL_VERSION=1.10.3
ARG _PACKER_VERSION=1.7.8
ARG _GO_VERSION=1.17.3
ARG _YQ_VERSION=4.14.1
ARG _TF_SWITCH_VERSION=0.12.1168

WORKDIR /root

# DEPENDENCIES
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
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
      wireguard-tools \
      iproute2 \
      iptables \
      tcpdump \
      openresolv \
      openssh-server \
      figlet \
      sshfs \
      iputils-ping && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN apt-get -s dist-upgrade | grep "^Inst" | \
    grep -i securi | awk -F " " {'print $2'} | \ 
    xargs apt-get install

# KUBECTL / HELM
RUN ARCH=$(cat /target_arch) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# PYTHON VIRTUAL ENVIRONMENT
RUN pip3 install virtualenv

# YQ
RUN wget https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_$(cat /target_arch) -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# VAULT
RUN wget https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_$(cat /target_arch).zip && \
    unzip vault_${_VAULT_VERSION}_linux_$(cat /target_arch).zip && \
    mv vault /usr/local/bin && \
    rm vault_${_VAULT_VERSION}_linux_$(cat /target_arch).zip

# TF_SWITCH
RUN wget https://github.com/warrensbox/terraform-switcher/releases/download/${_TF_SWITCH_VERSION}/terraform-switcher_${_TF_SWITCH_VERSION}_linux_$(cat /target_arch).tar.gz && \
    tar -xvzf terraform-switcher_${_TF_SWITCH_VERSION}_linux_$(cat /target_arch).tar.gz && \
    mv tfswitch /usr/local/bin && \
    rm terraform-switcher_${_TF_SWITCH_VERSION}_linux_$(cat /target_arch).tar.gz

# CONSUL
RUN wget https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_$(cat /target_arch).zip && \
    unzip consul_${_CONSUL_VERSION}_linux_$(cat /target_arch).zip && \
    mv consul /usr/local/bin && \
    rm consul_${_CONSUL_VERSION}_linux_$(cat /target_arch).zip

# PACKER
RUN wget https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_$(cat /target_arch).zip && \
    unzip packer_${_PACKER_VERSION}_linux_$(cat /target_arch).zip && \
    mv packer /usr/local/bin && \
    rm packer_${_PACKER_VERSION}_linux_$(cat /target_arch).zip

# GOLANG
RUN wget https://golang.org/dl/go${_GO_VERSION}.linux-$(cat /target_arch).tar.gz && \
    tar -xvzf go${_GO_VERSION}.linux-$(cat /target_arch).tar.gz && \
    mv go /usr/local/bin && \
    rm go${_GO_VERSION}.linux-$(cat /target_arch).tar.gz

# GCP CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y

# AWS CLI
RUN pip3 install awscli

# AZURE CLI
RUN apt update &&\
    apt install --yes libsodium-dev &&\
    SODIUM_INSTALL=system pip install pynacl &&\
    pip install azure-cli
    
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
