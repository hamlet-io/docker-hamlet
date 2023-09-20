# -------------------------------------------------------------------
# Base CI image
# This image is a general purpose CI image that also includes hamlet
# -------------------------------------------------------------------
FROM buildpack-deps:bookworm-scm AS base

USER root

# Basic Package installs
RUN apt-get update && apt-get install --no-install-recommends -y \
    # setup apt for different sources
    apt-utils apt-transport-https \
    ca-certificates gnupg2 \
    software-properties-common \
    git git-lfs \
    # Standard linux tools
    tar zip unzip less vim sudo iputils-ping \
    # hamlet req
    jq \
    # Python/PyEnv Reqs
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    # Builder Req
    libpq-dev libcurl4-openssl-dev \
    libedit-dev \
    && rm -rf /var/lib/apt/lists/*

# Add docker to apt-get
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce-cli docker-compose-plugin docker-buildx-plugin  \
    && rm -rf /var/lib/apt/lists/

# Add various java versions via apt-get
RUN curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://packages.adoptium.net/artifactory/deb \
    $(lsb_release -cs) \
    main"

RUN apt-get update && apt-get install --no-install-recommends -y \
    temurin-11-jdk temurin-17-jdk\
    && rm -rf /var/lib/apt/lists/

RUN echo "alias docker-compose='docker compose'" >> /etc/bash.bashrc

# Python Lang support
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# AWSCliv2 Install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
    && unzip "/tmp/awscliv2.zip" -d "/tmp/" && /tmp/aws/install && rm -rf /tmp/aws/

### Scripts for user env and entrypoint
COPY scripts/ /opt/tools/scripts/
COPY scripts/entrypoint.sh /entrypoint.sh

# Sudo support for apt-get installs
RUN /usr/sbin/groupadd appenv \
    && echo '#Allow everyone in appenv group to install packages' \
    && echo '%appenv ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/bin/bash" ]


# ----------------------
# General Image
# ----------------------

FROM base AS hamlet

### Setup a default user
ARG HAMLETUID=1003
ARG HOME=/home/hamlet

RUN useradd -u 1003 --shell /bin/bash --create-home hamlet \
    && chown hamlet:hamlet /home/hamlet && chmod u+rwx $HOME \
    && usermod -aG appenv hamlet

USER hamlet
WORKDIR $HOME

ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.jenv/bin:$HOME/.jenv/versions:$HOME/.jenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv JENV_ROOT=$HOME/.jenv

RUN echo 'export PS1='\''\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \w\[\033[0;32m\]\n$(git branch 2>/dev/null | grep "^*" | cut -d " " -f2)\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '\''' >> /home/hamlet/.bashrc
RUN mkdir -p ${HOME}/cmdb

## Setup user level stuff
RUN /opt/tools/scripts/setup_user_env.sh

# ----------------------
# Jenkins Inbound Agent
# ----------------------

FROM jenkins/inbound-agent:latest-jdk17 as jenkins-agent

USER root

ARG JENKINSUID=1000
ARG HOME=/home/jenkins

# Basic Package installs
RUN apt-get update && apt-get install --no-install-recommends -y \
    # setup apt for different sources
    apt-utils apt-transport-https \
    ca-certificates \
    gnupg2 \
    software-properties-common \
    git git-lfs \
    # Standard linux tools
    tar zip unzip \
    less vim sudo \
    iputils-ping \
    # hamlet req
    jq graphviz \
    # Python/PyEnv Reqs
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    # Builder Req
    libpq-dev libcurl4-openssl-dev \
    libedit-dev \
    && rm -rf /var/lib/apt/lists/*

RUN chsh jenkins --shell /bin/bash

# Add docker to apt-get
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce-cli docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/

# Add various java versions via apt-get
RUN curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://packages.adoptium.net/artifactory/deb \
    $(lsb_release -cs) \
    main"

# Fix for slim docker images not including the man directories
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && apt-get install --no-install-recommends -y \
    temurin-11-jdk temurin-17-jdk \
    && rm -rf /var/lib/apt/lists/

RUN echo "alias docker-compose='docker compose'" >> /etc/bash.bashrc

# Python Lang support
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# AWSCliv2 Install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
    && unzip "/tmp/awscliv2.zip" -d "/tmp/" && /tmp/aws/install && rm -rf /tmp/aws/

### Scripts for user env and entrypoint
COPY scripts/ /opt/tools/scripts/
COPY scripts/jenkins-agent/entrypoint.sh /entrypoint.sh

# Sudo support for apt-get installs
RUN /usr/sbin/groupadd appenv \
    && echo '#Allow everyone in appenv group to install packages' \
    && echo '%appenv ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers \
    && usermod -aG appenv jenkins

USER jenkins
WORKDIR $HOME

ENV JENKINS_AGENT_WORKDIR=${HOME} JENKINS_JAVA_BIN=/opt/java/openjdk/bin/java JENKINS_WEB_SOCKET=true

ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.jenv/bin:$HOME/.jenv/versions:$HOME/.jenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv JENV_ROOT=$HOME/.jenv

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

# Create the workspace directory so we can mount volumes to it and maintain user permissions
RUN mkdir -p ${HOME}/workspace

ENTRYPOINT [ "/entrypoint.sh" ]

# ----------------------------
# Azure Pipelines Agent Setup
# ----------------------------

FROM base as azure-pipelines-agent

USER root

ARG PIPELINESUID=1000
ARG HOME=/home/azp

RUN useradd -u ${PIPELINESUID} --shell /bin/bash --create-home azp \
    && chown azp:azp $HOME \
    && chmod u+rwx $HOME \
    && usermod -aG appenv azp \
    && usermod -aG sudo azp

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4 \
    libunwind8 \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/azpipelines-agent/start /usr/local/bin/start
RUN chmod +x /usr/local/bin/start \
    && chown azp:azp /usr/local/bin/start

USER azp

WORKDIR $HOME
ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.jenv/bin:$HOME/.jenv/versions:$HOME/.jenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv JENV_ROOT=$HOME/.jenv

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

ENTRYPOINT [ "/usr/local/bin/start" ]
