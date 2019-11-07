# -------------------------------------------------------
# Base gen3 Image
# -------------------------------------------------------
FROM openjdk:8-jdk AS gen3

USER root

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

RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/backports.list
RUN echo 'Package: * \n Pin: release o=Debian,a=testing  \n Pin-Priority: 900' | tee /etc/apt/preferences.d/backports

# Install Packages
RUN apt-get update && apt-get install -y \
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
    python3 python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Install Backport packages
RUN apt-get update && apt-get -t stretch-backports install -y \
   git-lfs \
   && rm -rf /var/lib/apt/lists/*

# Make Python3 the default
RUN update-alternatives --install /usr/bin/python python $(which python3) 10
RUN update-alternatives --install /usr/bin/pip pip $(which pip3) 10

# Install Python Packages
RUN pip install --upgrade --no-cache-dir \
        pip setuptools \
        virtualenv \
        docker-compose \
        PyYAML==3.12 \
        awscli \
        azure-cli \
        requests \
        cookiecutter

# Install NPM Packages
RUN npm install -g \
    bower \
    yamljs
