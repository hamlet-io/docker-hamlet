# -------------------------------------------------------------------
# Base CI image
# This image is a general purpose CI image that also includes hamlet
# -------------------------------------------------------------------
FROM buildpack-deps:bullseye-scm AS base

USER root

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

# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install --no-install-recommends -y \
        docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Python Lang support
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

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
ENV PATH=$HOME/.rbenv/bin:$HOME/.rbenv/versions:$HOME/.rbenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv RBENV_ROOT=$HOME/.rbenv

ENV GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-azure" \
        GENERATION_WRAPPER_LOCAL_JAVA="false" \
        GENERATION_WRAPPER_SCRIPT_FILE="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-wrapper/freemarker-wrapper-Linux/bin/freemarker-wrapper" \
        GENERATION_WRAPPER_JAR_FILE="" \
        GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash" \
        GENERATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/cli" \
        AUTOMATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation/jenkins/aws" \
        AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation"

RUN echo 'export PS1='\''\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \w\[\033[0;32m\]\n$(git branch 2>/dev/null | grep "^*" | cut -d " " -f2)\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '\''' >> /home/hamlet/.bashrc
RUN mkdir -p ${HOME}/cmdb

## Setup user level stuff
RUN /opt/tools/scripts/setup_user_env.sh

# ----------------------
# Jenkins Inbound Agent
# ----------------------

FROM jenkins/inbound-agent:latest-jdk11 as jenkins-agent

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

# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install --no-install-recommends -y \
        docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Python Lang support
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

### Scripts for user env and entrypoint
COPY scripts/ /opt/tools/scripts/
COPY scripts/entrypoint.sh /entrypoint.sh


# Sudo support for apt-get installs
RUN /usr/sbin/groupadd appenv \
        && echo '#Allow everyone in appenv group to install packages' \
        && echo '%appenv ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers \
        && usermod -aG appenv jenkins

USER jenkins
WORKDIR $HOME

ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.rbenv/bin:$HOME/.rbenv/versions:$HOME/.rbenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv RBENV_ROOT=$HOME/.rbenv

ENV GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-azure" \
        GENERATION_WRAPPER_LOCAL_JAVA="false" \
        GENERATION_WRAPPER_SCRIPT_FILE="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-wrapper/freemarker-wrapper-Linux/bin/freemarker-wrapper" \
        GENERATION_WRAPPER_JAR_FILE="" \
        GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash" \
        GENERATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/cli" \
        AUTOMATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation/jenkins/aws" \
        AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation"

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

# Create the workspace directory so we can mount volumes to it and maintain user permissions
RUN mkdir -p ${HOME}/workspace

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
ENV PATH=$HOME/.rbenv/bin:$HOME/.rbenv/versions:$HOME/.rbenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv RBENV_ROOT=$HOME/.rbenv

ENV GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-azure" \
        GENERATION_WRAPPER_LOCAL_JAVA="false" \
        GENERATION_WRAPPER_SCRIPT_FILE="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-wrapper/freemarker-wrapper-Linux/bin/freemarker-wrapper" \
        GENERATION_WRAPPER_JAR_FILE="" \
        GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash" \
        GENERATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/cli" \
        AUTOMATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation/jenkins/aws" \
        AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation"

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

ENTRYPOINT [ "/usr/local/bin/start" ]


# ----------------------------
# meteor variants
# ----------------------------

# Each of these runs user specific setup processes for the user its running under

FROM hamlet as meteor-hamlet

COPY scripts/meteor /opt/tools/scripts/meteor
ENV PATH=$HOME/.meteor:$PATH
RUN /opt/tools/scripts/meteor/setup_meteor.sh


FROM jenkins-agent AS meteor-jenkins-agent

COPY scripts/meteor /opt/tools/scripts/meteor
ENV PATH=$HOME/.meteor:$PATH
RUN /opt/tools/scripts/meteor/setup_meteor.sh


FROM azure-pipelines-agent AS meteor-azure-pipelines-agent

COPY scripts/meteor /opt/tools/scripts/meteor
ENV PATH=$HOME/.meteor:$PATH
RUN /opt/tools/scripts/meteor/setup_meteor.sh
