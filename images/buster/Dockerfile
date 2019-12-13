# -------------------------------------------------------
# Base gen3 Image
# -------------------------------------------------------
FROM buildpack-deps:buster AS gen3

USER root

ARG COTUID=333

# Install CodeOnTap
ARG CODEONTAP_VERSION=master
ARG DOCKER_IMAGE_VERSION=master

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup
ENV GENERATION_PLUGIN_DIRS=/opt/codeontap/plugins

RUN useradd -u ${COTUID} --shell /bin/bash --create-home codeontap && \
        mkdir /home/codeontap/cmdb

# Install OS Packages
# setup apt for different sources
RUN apt-get update && apt-get install --no-install-recommends -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
   && rm -rf /var/lib/apt/lists/*

# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Add Node to apt-get
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -

# Add Yarn to apt-get
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    curl wget \
    dos2unix \
    git \
    tar zip unzip \
    less vim tree \
    jq \
    groff \
    docker-ce \
    nodejs yarn \
    locales \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen "en_US.UTF-8"

# Add Unstable sources
RUN echo "deb http://deb.debian.org/debian unstable main" | tee /etc/apt/sources.list.d/unstable.list
RUN echo 'Package: * \n Pin: release o=Debian,a=unstable  \n Pin-Priority: 900' | tee /etc/apt/preferences.d/unstable

RUN apt-get update && apt-get install --no-install-recommends -y \
    openjdk-8-jdk

# Setup PyEnv
ENV PYTHON_VERSION=3.6.9
ENV PYTHON2_VERSION=2.7.16

# PyEnv requirements
RUN apt-get update && apt-get install --no-install-recommends -y \
    make build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

ENV LANG C.UTF-8
ENV PYENV_ROOT=/usr/local/opt/pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN ln -s /usr/local/opt/pyenv/bin/pyenv /usr/local/bin/pyenv
ENV PATH="${PYENV_ROOT}/shims:${PATH}"

RUN pyenv install "${PYTHON_VERSION}" && pyenv install "${PYTHON2_VERSION}" && pyenv global "${PYTHON_VERSION}"

# Install Python Packages
RUN python --version && python -m pip install --upgrade --no-cache-dir pip
RUN python -m pip install --upgrade --no-cache-dir \
        setuptools \
        pipenv \
        virtualenv \
        docker-compose \
        PyYAML==3.12 \
        awscli \
        azure-cli \
        requests \
        cookiecutter

# Install NPM Packages
RUN npm install -g \
    yamljs

# Directory set up and file copying
RUN mkdir -p /build/scripts &&  mkdir -p /opt/codeontap && mkdir -p /opt/codeontap/plugins

COPY scripts/base/ /build/scripts/
COPY config.json /build/config.json

# Get CodeOnTap code
RUN chmod -R u+rwx /build/scripts && \
    chmod u+s /build/ && \
    chmod -R ugo+rx /opt/codeontap

RUN echo "Cloning images on $(date +%s)"
RUN /build/scripts/build_codeontap.sh && \
    /build/scripts/clone.sh

# Install the cli
WORKDIR /opt/codeontap/cli/gen3-cli
RUN python setup.py bdist_wheel && \
        pip install --no-index --find-links=dist codeontap-cli

# change back to standard repo location
USER codeontap
WORKDIR /home/codeontap/cmdb
