# -------------------------------------------------------
# gen3 base image - apline based
# -------------------------------------------------------
FROM openjdk:8-jdk-alpine AS base

USER root

# Install OS Packages
RUN apk add --no-cache \
        ca-certificates \
        gnupg \
        curl wget \
        dos2unix \
        git \
        bash bash-completion \
        shadow sudo \
        tar zip unzip \
        less vim tree \
        jq \
        groff \
        docker \
        nodejs \
        npm \
        yarn \
        python3 \
        py3-virtualenv 

# Configure Python3 to work as default python
ENV PATH /usr/local/bin:$PATH

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s $(which pydoc3)    pydoc \
	&& ln -s $(which python3)   python \
    && ln -s $(which pip3)      pip

RUN pip install --upgrade --no-cache-dir \
        docker-compose \
        virtualenv \
        PyYAML==3.12 \
        awscli \ 
        cookiecutter

# Install NPM Packages
RUN npm install -g \
    bower
    
CMD ["/bin/bash"]