# -------------------------------------------------------
# Base gen3 Image
# -------------------------------------------------------
FROM buildpack-deps:stretch-scm AS base

USER root

#Docker user
ARG DOCKERGID=497

# Hamlet Version Control
ARG HAMLET_VERSION=master
ARG DOCKER_IMAGE_VERSION=master

## Standard Hamlet Env vars
ENV AUTOMATION_BASE_DIR=/opt/hamlet/executor/automation
ENV AUTOMATION_DIR=/opt/hamlet/executor/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/hamlet/executor
ENV GENERATION_DIR=/opt/hamlet/executor/cli
ENV GENERATION_ENGINE_DIR=/opt/hamlet/engine/core
ENV GENERATION_PLUGIN_DIRS=/opt/hamlet/engine/plugins/aws;/opt/hamlet/engine/plugins/azure
ENV GENERATION_STARTUP_DIR=/opt/hamlet/startup
ENV GENERATION_PATTERNS_DIR=/opt/hamlet/patterns

# Install OS Packages
RUN apt-get update && apt-get install --no-install-recommends -y \
        # setup apt for different sources
        apt-utils \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common \
        # Standard linux tools
        dos2unix \
        tar zip unzip \
        less vim tree \
        jq \
        groff \
        # Freemarker Req
        openjdk-8-jdk \
        # Python/PyEnv Reqs
        make build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
        libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
        libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
        # Builder Req
        libpq-dev libcurl4-openssl-dev \
        libncursesw5-dev libedit-dev \
        # Diagram Generation
        graphviz \
   && rm -rf /var/lib/apt/lists/*

# -- Install extra library packages --
# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Add Backports sources
RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/backports.list
RUN echo 'Package: * \n Pin: release a=stretch-backports \n Pin-Priority: 900' | tee /etc/apt/preferences.d/backports

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce-cli \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Add docker user for docker bind mount
RUN groupadd -g "${DOCKERGID}" docker

# PyEnv requirements
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHON_VERSION 3.6.8

ENV PYENV_ROOT /usr/local/opt/pyenv
RUN git clone --branch "v1.2.15" --depth 1 https://github.com/pyenv/pyenv.git "${PYENV_ROOT}" && \
        git clone --branch "v1.1.5" --depth 1 https://github.com/pyenv/pyenv-virtualenv.git "${PYENV_ROOT}/plugins/pyenv-virtualenv" && \
        git clone --branch "v0.0.2" --depth 1 https://github.com/pyenv/pyenv-which-ext.git "${PYENV_ROOT}/plugins/pyenv-which-ext"

# Allow anyone to install a python version for builds
RUN mkdir "${PYENV_ROOT}/versions/" && chmod go+w --recursive "${PYENV_ROOT}/versions/" && \
        mkdir "${PYENV_ROOT}/shims/" && chmod go+w --recursive "${PYENV_ROOT}/shims/" && \
        touch "${PYENV_ROOT}/version" && chmod go+w "${PYENV_ROOT}/version"

RUN ln -s /usr/local/opt/pyenv/bin/pyenv /usr/local/bin/pyenv
ENV PATH="${PYENV_ROOT}/shims:${PATH}"
RUN pyenv install "${PYTHON_VERSION}" && eval "$(pyenv init -)" && \
        pyenv global "${PYTHON_VERSION}" && python --version && pip install --upgrade --no-cache-dir pip

# Install Python Packages
RUN pip install --upgrade --no-cache-dir \
        setuptools \
        pipenv \
        virtualenv \
        docker-compose \
        PyYAML \
        awscli \
        azure-cli \
        requests \
        cookiecutter \
        zappa \
        pytest \
        pytest-sugar \
        pytest-django \
        coverage \
        flake8

# Install Azure CLI Extensions (default location is in $HOME)
ENV AZURE_EXTENSION_DIR=/opt/azcliextensions
RUN mkdir /opt/azcliextensions
RUN az extension add --name front-door
RUN chmod 0755 --recursive /opt/azcliextensions

# rbenv requirements
ENV RUBY_VERSION 2.5.1

ENV RBENV_ROOT /usr/local/opt/rbenv
RUN git clone --branch "v1.1.2" --depth 1 https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" && \
        git clone --branch "v20191225" --depth 1 https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"
RUN ln -s /usr/local/opt/rbenv/bin/rbenv /usr/local/bin/rbenv

# Allow anyone to install a ruby version for builds
RUN mkdir "${RBENV_ROOT}/versions/" && chmod go+w --recursive "${RBENV_ROOT}/versions/" && \
        mkdir "${RBENV_ROOT}/shims/" && chmod go+w --recursive "${RBENV_ROOT}/shims/" && \
        touch "${RBENV_ROOT}/version" && chmod go+w "${RBENV_ROOT}/version"

ENV PATH="${RBENV_ROOT}/shims:${PATH}"
RUN rbenv install "${RUBY_VERSION}" && eval "$(rbenv init -)" && \
        rbenv global "${RUBY_VERSION}" && ruby --version

# Install Ruby Packages
RUN gem install \
        cfn-nag

# nodenv requirements
ENV NODE_VERSION 10.22.0

ENV NODENV_ROOT /usr/local/opt/nodenv
RUN git clone --depth 1 https://github.com/nodenv/nodenv.git "${NODENV_ROOT}" && \
        git clone --depth 1 https://github.com/nodenv/node-build.git "${NODENV_ROOT}/plugins/node-build" && \
        git clone --depth 1 https://github.com/nodenv/nodenv-aliases.git "${NODENV_ROOT}/plugins/nodenv-aliases" && \
        git clone --depth 1 https://github.com/nodenv/node-build-update-defs.git "${NODENV_ROOT}/plugins/node-build-update-defs"

RUN ln -s /usr/local/opt/nodenv/bin/nodenv /usr/local/bin/nodenv

# Allow anyone to install a ruby version for builds
RUN mkdir "${NODENV_ROOT}/versions/" && chmod go+w --recursive "${NODENV_ROOT}/versions/" && \
        mkdir "${NODENV_ROOT}/shims/" && chmod go+w --recursive "${NODENV_ROOT}/shims/" && \
        touch "${NODENV_ROOT}/version" && chmod go+w "${NODENV_ROOT}/version"

ENV PATH="${NODENV_ROOT}/shims:${NODENV_ROOT}/versions/${NODE_VERSION}/bin:${PATH}"

RUN eval "$(nodenv init -)" && \
        nodenv install "${NODE_VERSION}" && nodenv update-version-defs && \
        nodenv global "${NODE_VERSION}" && node --version

# Install Global NPM Packages
RUN npm install -g \
    yamljs \
    grunt-cli \
    gulp-cli \
    yarn

# Directory set up and file copying
RUN mkdir -p /build/scripts && \
      mkdir -p /opt/hamlet/ && \
      mkdir -p /opt/hamlet/engine && \
      mkdir -p /opt/hamlet/engine/plugins

# Get Hamlet code
COPY scripts/base/ /build/scripts/
COPY config.json /build/config.json

RUN chmod -R u+rwx /build/scripts && \
    chmod u+s /build/ && \
    chmod -R ugo+rx /opt/hamlet

RUN echo "Cloning images on $(date +%s)" && \
	/build/scripts/build_hamlet.sh && \
        /build/scripts/clone.sh

# Install the hamlet cli
WORKDIR /opt/hamlet/cli/hamlet-cli
RUN python setup.py bdist_wheel && \
        pip install -r requirements/prod.txt && \
        pip install --find-links=dist --no-index hamlet-cli

WORKDIR /root

ENTRYPOINT [ "/bin/bash" "-c "$@"" ]
