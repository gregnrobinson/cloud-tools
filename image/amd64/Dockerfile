FROM ubuntu:20.04
COPY ../../.devcontainer/config/.bashrc /root/.bashrc

ARG PLATFORM=amd64

# PACKAGE VERSIONS
ARG DEBIAN_FRONTEND=noninteractive
ARG _VAULT_VERSION=1.9.2
ARG _CONSUL_VERSION=1.10.4
ARG _PACKER_VERSION=1.7.8
ARG _GO_VERSION=1.17.5
ARG _YQ_VERSION=4.16.2
ARG _TF_SWITCH_VERSION=0.13.1201

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
      ctop \
      nmap \
      dhcping \
      iperf \
      openresolv \
      openssh-server \
      figlet \
      sshfs \
      netcat \
      build-essential \
      iputils-ping && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# KUBECTL / HELM
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${PLATFORM}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
    rm -rf ./kubectl &&\
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# INSTALL KUBECTX/KUBENS
RUN git clone https://github.com/ahmetb/kubectx /usr/local/kubectx &&\
    ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx &&\
    ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

# PYTHON VIRTUAL ENVIRONMENT
RUN pip3 install virtualenv

# YQ
RUN wget "https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_${PLATFORM}" -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# VAULT
RUN wget "https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip" && \
    unzip vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip && \
    mv vault /usr/local/bin && \
    rm vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip

# TF_SWITCH
RUN wget "https://github.com/warrensbox/terraform-switcher/releases/download/${_TF_SWITCH_VERSION}/terraform-switcher_${_TF_SWITCH_VERSION}_linux_${PLATFORM}.tar.gz" && \
    tar -xvzf terraform-switcher_${_TF_SWITCH_VERSION}_linux_${PLATFORM}.tar.gz && \
    mv tfswitch /usr/local/bin && \
    rm terraform-switcher_${_TF_SWITCH_VERSION}_linux_${PLATFORM}.tar.gz

# CONSUL
RUN wget "https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip" && \
    unzip consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip && \
    mv consul /usr/local/bin && \
    rm consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip

# PACKER
RUN wget "https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip" && \
    unzip packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip && \
    mv packer /usr/local/bin && \
    rm packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip

# GOLANG
RUN wget "https://golang.org/dl/go${_GO_VERSION}.linux-${PLATFORM}.tar.gz" && \
    tar -xvzf go${_GO_VERSION}.linux-${PLATFORM}.tar.gz && \
    mv go /usr/local/bin && \
    rm go${_GO_VERSION}.linux-${PLATFORM}.tar.gz

# GCP CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-cli main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y

# AWS CLI
RUN pip3 install awscli==1.21.12

# ASM CLI
RUN curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > /usr/local/bin/asmcli &&\
    chmod +x /usr/local/bin/asmcli

# EKSCTL CLI
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${PLATFORM}.tar.gz" | tar xz -C /tmp &&\
    mv /tmp/eksctl /usr/local/bin

# ISTIOCTL
RUN curl -L https://istio.io/downloadIstio | sh -

# KPT
RUN mkdir -p ~/bin &&\
    curl -L https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.1/kpt_linux_amd64 --output ~/bin/kpt && chmod u+x ~/bin/kpt &&\
    export PATH=${HOME}/bin:${PATH}

# AZURE CLI
RUN apt update &&\
    apt install --yes libsodium-dev &&\
    SODIUM_INSTALL=system pip install pynacl==1.4.0 &&\
    pip install azure-cli==2.30.0 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
