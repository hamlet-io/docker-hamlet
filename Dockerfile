# ----------------------------
# Base image
# ----------------------------
FROM buildpack-deps:stretch-scm AS base

USER root

# Hamlet Version Control
ARG DOCKER_IMAGE_VERSION=latest

# Basic Package installs
RUN apt-get update && apt-get install --no-install-recommends -y \
        # setup apt for different sources
        apt-utils \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common \
        # Standard linux tools
        tar zip unzip \
        less vim tree groff \
        sudo \
        iputils-ping \
        netcat \
        # hamlet req
        jq dos2unix \
        openjdk-8-jdk \
        graphviz \
        # Python/PyEnv Reqs
        make build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
        libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
        libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
        # Builder Req
        libpq-dev libcurl4-openssl-dev \
        libncursesw5-dev libedit-dev \
   && rm -rf /var/lib/apt/lists/*

# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Add Backports sources
RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/backports.list && \
        echo 'Package: * \n Pin: release a=stretch-backports \n Pin-Priority: 900' | tee /etc/apt/preferences.d/backports

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce-cli \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

#Docker config
ARG DOCKERGID=497
ENV DOCKER_API_VERSION=1.39
RUN groupadd -g "${DOCKERGID}" docker \
        && groupmod -g "${DOCKERGID}" docker

RUN /usr/sbin/groupadd appenv

# Docker
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

### Tool scripts that are run by users
COPY scripts/ /opt/tools/scripts/
RUN chmod -R ugo+rx  /opt/tools/scripts/

### Entrypoint setup
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod ugo+rx /entrypoint.sh

RUN echo '#Allow everyone in appenv group to install packages' \
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
        && usermod -aG appenv hamlet \
        && usermod -aG docker hamlet

USER hamlet
WORKDIR $HOME

ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.rbenv/bin:$HOME/.rbenv/versions:$HOME/.rbenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv RBENV_ROOT=$HOME/.rbenv

ENV GENERATION_ENGINE_DIR="$HOME/.hamlet/engine/engines/_global/shim/engine-core" \
        GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-azure" \
        GENERATION_BIN_DIR="$HOME/.hamlet/engine/engines/_global/shim/engine-binary" \
        GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash" \
        GENERATION_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/cli" \
        AUTOMATION_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation/jenkins/aws"\
        AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation"

RUN echo 'export PS1='\''\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \w\[\033[0;32m\]\n$(git branch 2>/dev/null | grep "^*" | cut -d " " -f2)\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '\''' >> /home/hamlet/.bashrc
RUN mkdir -p ${HOME}/cmdb

## Setup user level stuff

RUN /opt/tools/scripts/setup_user_env.sh



# ----------------------
# Jenkins TCP/JNLP Agent
# ----------------------

FROM base as jenkins-jnlp-agent

USER root

ARG JENKINSUID=1000
ARG HOME=/home/jenkins

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${JENKINSUID} --shell /bin/bash --create-home jenkins \
        && chown jenkins:jenkins $HOME && chmod u+rwx $HOME \
        && usermod -aG appenv jenkins \
        && usermod -aG docker jenkins

# See https://github.com/jenkinsci/docker-inbound-agent/blob/master/jenkins-agent
ARG JENKINS_REMOTING_VERSION=4.7
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_REMOTING_VERSION}/remoting-${JENKINS_REMOTING_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar

COPY scripts/jenkins-jnlp-agent/ /usr/local/bin/
RUN chmod 755 /usr/local/bin/wait-for-it \
    && chmod 755 /usr/local/bin/jenkins-agent

USER jenkins
WORKDIR $HOME

ENV PATH=$HOME/.nodenv/bin:$HOME/.nodenv/versions:$HOME/.nodenv/shims:$PATH
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/versions:$HOME/.pyenv/shims:$PATH
ENV PATH=$HOME/.rbenv/bin:$HOME/.rbenv/versions:$HOME/.rbenv/shims:$PATH
ENV PYENV_ROOT=$HOME/.pyenv NODENV_ROOT=$HOME/.nodenv RBENV_ROOT=$HOME/.rbenv

ENV GENERATION_ENGINE_DIR="$HOME/.hamlet/engine/engines/_global/shim/engine-core" \
        GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-azure" \
        GENERATION_BIN_DIR="$HOME/.hamlet/engine/engines/_global/shim/engine-binary" \
        GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash" \
        GENERATION_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/cli" \
        AUTOMATION_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation/jenkins/aws"\
        AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation"

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

# Create the workspace directory so we can mount volumes to it and maintain user permissions
RUN mkdir -p ${HOME}/workspace

ENTRYPOINT [ "/usr/local/bin/jenkins-agent"]



# ----------------------------
# Azure Pipelines Agent Setup
# ----------------------------

FROM base as azure-pipelines-agent

USER root

ARG PIPELINESUID=1000
ARG HOME=/home/azp
ARG DOCKERGID=115

RUN useradd -u ${PIPELINESUID} --shell /bin/bash --create-home azp \
  && groupmod -g "${DOCKERGID}" docker \
  && chown azp:azp $HOME && chmod u+rwx $HOME \
  && usermod -aG docker azp \
  && usermod -aG appenv azp \
  && usermod -aG sudo azp \
  && echo '%docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                libcurl3 \
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

ENV GENERATION_ENGINE_DIR=$HOME/.hamlet/engine/engines/_global/shim/engine-core \
        GENERATION_PLUGIN_DIRS=$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/_global/shim/engine-plugin-azure \
        GENERATION_BIN_DIR=$HOME/.hamlet/engine/engines/_global/shim/engine-binary \
        GENERATION_BASE_DIR=$HOME/.hamlet/engine/engines/_global/shim/executor-bash \
        GENERATION_DIR=$HOME/.hamlet/engine/engines/_global/shim/executor-bash/cli \
        AUTOMATION_DIR=$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation/jenkins/aws \
        AUTOMATION_BASE_DIR=$HOME/.hamlet/engine/engines/_global/shim/executor-bash/automation

## Setup the user specific tooling
RUN /opt/tools/scripts/setup_user_env.sh

ENTRYPOINT [ "/usr/local/bin/start" ]



# ----------------------------
# meteor variants
# ----------------------------

# Each of these runs user specific setup processes for the user its running under

FROM hamlet as meteor-hamlet

COPY scripts/meteor /opt/tools/scripts/meteor
RUN /opt/tools/scripts/meteor/setup_meteor.sh


FROM jenkins-jnlp-agent AS meteor-jenkins-jnlp-agent

COPY scripts/meteor /opt/tools/scripts/meteor
RUN /opt/tools/scripts/meteor/setup_meteor.sh


FROM azure-pipelines-agent AS meteor-azure-pipelines-agent

COPY scripts/meteor /opt/tools/scripts/meteor
RUN /opt/tools/scripts/meteor/setup_meteor.sh
