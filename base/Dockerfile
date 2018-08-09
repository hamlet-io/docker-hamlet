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
    docker-ce \
    nodejs \
    npm \
    yarn \
    python3 \
    python3-dev \
    python3-pip \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Add Debian testing repos
RUN echo 'deb http://deb.debian.org/debian testing main' | tee -a /etc/apt/sources.list 
RUN echo 'APT::Default-Release "stable";' | tee -a /etc/apt/apt.conf.d/00local

# Install Python3.6
RUN apt-get update && apt-get -t testing install -y \
    python3.6 \
    python3.6-dev \
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
    cookiecutter

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli \
    bower

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
