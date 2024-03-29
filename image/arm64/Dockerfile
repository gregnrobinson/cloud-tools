FROM debian:bookworm-slim
COPY .devcontainer/config/.bashrc /root/.bashrc

ARG PLATFORM=arm64

# Options include 64bit or arm64
ARG AWS_SESSION_MANAGER_ARCH="arm64"

# Options include x86_64 for amd64 or aarch64 for arm64
ARG AWS_CLI_ARCH="aarch64"

# PACKAGE VERSIONS
ARG DEBIAN_FRONTEND=noninteractive
ARG _VAULT_VERSION=1.9.2
ARG _CONSUL_VERSION=1.10.4
ARG _PACKER_VERSION=1.7.8
ARG _GO_VERSION=1.17.5
ARG _YQ_VERSION=4.16.2
ARG _TF_SWITCH_VERSION=0.13.1201
ARG _ANSIBLE_VERSION=2.9.27

WORKDIR /root

# DEPENDENCIES
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    apt install -y curl unzip python3-pip vim python3-boto3 libhdf5-dev libssl-dev libffi-dev figlet python3-dev vim nodejs git wget jq &&\
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# INSTALL ANSIBLE
RUN pip3 install --upgrade pip cffi && \
    pip install ansible==${_ANSIBLE_VERSION} && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    rm -rf /root/.cache/pip

# KUBECTL / HELM
RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${PLATFORM}/kubectl" && \
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
RUN wget -q "https://github.com/mikefarah/yq/releases/download/v${_YQ_VERSION}/yq_linux_${PLATFORM}" -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# VAULT
RUN wget -q "https://releases.hashicorp.com/vault/${_VAULT_VERSION}/vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip" && \
    unzip -qq vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip && \
    mv vault /usr/local/bin && \
    rm vault_${_VAULT_VERSION}_linux_${PLATFORM}.zip

# TF_SWITCH
RUN wget -q https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh && \
    chmod 755 install.sh && \
    ./install.sh -b /usr/local/bin

# CONSUL
RUN wget -q "https://releases.hashicorp.com/consul/${_CONSUL_VERSION}/consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip" && \
    unzip -qq consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip && \
    mv consul /usr/local/bin && \
    rm consul_${_CONSUL_VERSION}_linux_${PLATFORM}.zip

# PACKER
RUN wget -q "https://releases.hashicorp.com/packer/${_PACKER_VERSION}/packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip" && \
    unzip -qq packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip && \
    mv packer /usr/local/bin && \
    rm packer_${_PACKER_VERSION}_linux_${PLATFORM}.zip

# GOLANG
RUN wget -q "https://golang.org/dl/go${_GO_VERSION}.linux-${PLATFORM}.tar.gz" && \
    tar -xzf go${_GO_VERSION}.linux-${PLATFORM}.tar.gz && \
    mv go /usr/local/bin && \
    rm go${_GO_VERSION}.linux-${PLATFORM}.tar.gz

# GCP CLI
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
    apt-get update && apt-get install google-cloud-cli

# AWS CLI
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_CLI_ARCH}.zip" -o "awscliv2.zip" && \
    unzip -qq awscliv2.zip && \
    ./aws/install

# INSTALL SESSION MANAGER PLUGIN
RUN curl -s "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_${AWS_SESSION_MANAGER_ARCH}/session-manager-plugin.deb" -o session-manager-plugin.deb && \
    dpkg -i session-manager-plugin.deb

# ASM CLI
RUN curl -s https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.12 > /usr/local/bin/asmcli &&\
    chmod +x /usr/local/bin/asmcli

# EKSCTL CLI
RUN curl -s --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_${PLATFORM}.tar.gz" | tar xz -C /tmp &&\
    mv /tmp/eksctl /usr/local/bin

# ISTIOCTL
RUN curl -sL https://istio.io/downloadIstio | sh -

# KPT
RUN mkdir -p ~/bin &&\
    curl -sL https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.1/kpt_linux_amd64 --output ~/bin/kpt && chmod u+x ~/bin/kpt &&\
    export PATH=${HOME}/bin:${PATH}

# AZURE CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
