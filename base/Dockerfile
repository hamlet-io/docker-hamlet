FROM openjdk:8-jdk

USER root

# Directory set up and file copying 
RUN mkdir -p /build/scripts
RUN mkdir -p /opt/codeontap

COPY scripts/ /build/scripts/
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
    python3 python3-pip \
    docker-ce \
    nodejs \
    npm \
    yarn \
 && rm -rf /var/lib/apt/lists/*

# Make Python3 the default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

# Install Python Packages
RUN pip install --upgrade --no-cache-dir \
    pip setuptools \
    awscli \ 
    cookiecutter

# Install NPM Packages
RUN npm install -g grunt-cli

# Update Script permissions
RUN chmod -R u+rwx /build/scripts
RUN chmod u+s /build/
RUN chmod -R ugo+rx /opt/codeontap 

RUN /build/scripts/build_codeontap.sh
RUN /build/scripts/clone.sh

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup

ENV REGION=""
ENV ACCOUNT=""
ENV PRODUCT=""
ENV ENVIRONMENT=""
ENV SEGMENT=""
