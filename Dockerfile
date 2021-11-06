
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

# PACKAGE VERSIONS
ARG DEBIAN_FRONTEND=noninteractive
ARG _VAULT_VERSION=1.7.1
ARG _CONSUL_VERSION=1.9.5
ARG _PACKER_VERSION=1.7.2
ARG _GO_VERSION=1.16.4
ARG _YQ_VERSION=4.2.0
ARG _TF_SWITCH_VERSION=0.12.1168

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
      sshfs \
      iputils-ping && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# KUBECTL
RUN ARCH=$(cat /target_arch) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# PYTHON VIRTUAL ENVIRONMENT
RUN pip3 install virtualenv

# YQ
RUN wget https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_$(cat /target_arch) -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

## VAULT
#RUN wget https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    unzip vault_${_VAULT_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    mv vault /usr/local/bin && \
#    rm vault_${_VAULT_VERSION}_linux_${TARGETPLATFORM##*/}.zip
#
## TF_SWITCH
#RUN wget https://github.com/warrensbox/terraform-switcher/releases/download/${_TF_SWITCH_VERSION}/terraform-switcher_${_TF_SWITCH_VERSION}_linux_${TARGETPLATFORM##*/}.tar.gz && \
#    tar -xvzf terraform-switcher_${_TF_SWITCH_VERSION}_linux_${TARGETPLATFORM##*/}.tar.gz && \
#    mv tfswitch /usr/local/bin && \
#    rm terraform-switcher_${_TF_SWITCH_VERSION}_linux_${TARGETPLATFORM##*/}.tar.gz
#
## CONSUL
#RUN wget https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    unzip consul_${_CONSUL_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    mv consul /usr/local/bin && \
#    rm consul_${_CONSUL_VERSION}_linux_${TARGETPLATFORM##*/}.zip
#
## PACKER
#RUN wget https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    unzip packer_${_PACKER_VERSION}_linux_${TARGETPLATFORM##*/}.zip && \
#    mv packer /usr/local/bin && \
#    rm packer_${_PACKER_VERSION}_linux_${TARGETPLATFORM##*/}.zip
#
## GOLANG
#RUN wget https://golang.org/dl/go${_GO_VERSION}.linux-${TARGETPLATFORM##*/}.tar.gz && \
#    tar -xvzf go${_GO_VERSION}.linux-${TARGETPLATFORM##*/}.tar.gz && \
#    mv go /usr/local/bin && \
#    rm go${_GO_VERSION}.linux-${TARGETPLATFORM##*/}.tar.gz
#
## GCP CLI
#RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
#    apt-get update -y && \
#    apt-get install google-cloud-sdk -y
#
## AWS CLI
#RUN pip3 install awscli
#
## AZURE CLI
#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
#    apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg && \
#    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
#    AZ_REPO=$(lsb_release -cs) && \
#    echo "deb [arch=${TARGETPLATFORM##*/}] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
#    apt-get update -y && \
#    apt-get install -y azure-cli
#
## BASH
#ENTRYPOINT ["/bin/bash"]
#