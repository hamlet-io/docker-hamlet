# -------------------------------------------------------
# Base gen3 Image
# -------------------------------------------------------
FROM openjdk:8-jdk AS gen3

USER root

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup

# Directory set up and file copying 
RUN mkdir -p /build/scripts
RUN mkdir -p /opt/codeontap

COPY scripts/base/ /build/scripts/
COPY config.json /build/config.json

# Install OS Packages

# setup apt for different sources
RUN apt-get update && apt-get install -y \
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
RUN curl -sL https://deb.nodesource.com/setup_8.x |  bash - 

# Add Yarn to apt-get
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list 

# Install Packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    build-essential \
    curl wget \
    dos2unix \
    git \
    tar zip unzip \
    less vim tree \
    jq \
    groff \
    docker-ce \
    nodejs \
    npm \
    yarn \
    python3 \
    python3-dev \
    python3-pip \
    libpq-dev \
    libcurl4-openssl-dev libssl-dev \
 && rm -rf /var/lib/apt/lists/*

# Add Debian testing repos
RUN echo 'deb http://deb.debian.org/debian testing main' | tee -a /etc/apt/sources.list 
RUN echo 'APT::Default-Release "stable";' | tee -a /etc/apt/apt.conf.d/00local

# Install Python3.6
RUN apt-get update && apt-get -t testing install -y \
    python3.6 \
 && rm -rf /var/lib/apt/lists/*

# Make Python3 the default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

# Install Python Packages
RUN pip install --upgrade --no-cache-dir \
    pip setuptools \
    virtualenv \
    docker-compose \
    PyYAML==3.12 zappa \
    awscli \ 
    cookiecutter \
    pytest pytest-sugar pytest-django coverage flake8 

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli \
    bower \
    yamljs

# -------------------------------------------------------
# Jenkins JNLP Agent 
# -------------------------------------------------------
FROM gen3 AS jenkins-jnlp-agent

USER root

ARG JENKINSUID=1000
ARG DOCKERGID=497

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${JENKINSUID} --shell /bin/bash --create-home jenkins \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -G docker jenkins

RUN echo '#Allow Jenkins user to install extra packages'
RUN echo 'jenkins ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

# See https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile#L31
ARG JENKINS_REMOTING_VERSION=3.28
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY scripts/jenkins-jnlp-agent/jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod 755 /usr/local/bin/jenkins-agent

COPY scripts/jenkins-jnlp-agent/wait-for-it /usr/local/bin/wait-for-it
RUN chmod 755 /usr/local/bin/wait-for-it

WORKDIR /home/jenkins
USER jenkins

VOLUME /var/lib/docker

ENTRYPOINT [ "/usr/local/bin/jenkins-agent"]

# -------------------------------------------------------
# Jenkins JNLP Agent - With precached Meteor
# -------------------------------------------------------
FROM jenkins-jnlp-agent AS jenkins-jnlp-meteor-agent

FROM codeontap/gen3-jenkins-slave:latest

USER root

ENV METEOR_RELEASE=1.8.0.1

#Install Meteor
RUN curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER jenkins

# Creates an app which forces the local cache to be created
RUN meteor create --release ${METEOR_RELEASE} --full ~/dummyapp/src && cd ~/dummyapp/src && meteor npm install && meteor build ~/dummyapp/dist --directory && rm -rf ~/dummyapp
