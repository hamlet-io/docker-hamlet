ARG BASE_IMAGE=hamletio/hamlet:latest

FROM ${BASE_IMAGE} AS hamlet

USER root

ARG HAMLETUID=1003

# Install Hamlet
ARG HAMLET_VERSION=master
ARG DOCKER_IMAGE_VERSION=master

## bash based executor setup
ENV AUTOMATION_BASE_DIR=/opt/hamlet/executor/automation
ENV AUTOMATION_DIR=/opt/hamlet/executor/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/hamlet/executor
ENV GENERATION_DIR=/opt/hamlet/executor/cli

# Engine Setup
ENV GENERATION_ENGINE_DIR=/opt/hamlet/engine/core
ENV GENERATION_PLUGIN_DIRS=/opt/hamlet/engine/plugins/aws;/opt/hamlet/engine/plugins/azure

ENV GENERATION_STARTUP_DIR=/opt/hamlet/startup

RUN useradd -u ${HAMLETUID} --shell /bin/bash --create-home hamlet && \
        mkdir /home/hamlet/cmdb && chown hamlet:hamlet /home/hamlet/cmdb

# Directory set up and file copying
RUN mkdir -p /build/scripts && \
      mkdir -p /opt/hamlet/ && \
      mkdir -p /opt/hamlet/engine && \
      mkdir -p /opt/hamlet/engine/plugins

COPY scripts/base/ /build/scripts/
COPY config.json /build/config.json

# Get Hamlet code
RUN chmod -R u+rwx /build/scripts && \
    chmod u+s /build/ && \
    chmod -R ugo+rx /opt/hamlet

RUN echo "Cloning images on $(date +%s)"
RUN /build/scripts/build_hamlet.sh && \
    /build/scripts/clone.sh

# Install the cli
WORKDIR /opt/hamlet/cli/gen3-cli
RUN python setup.py bdist_wheel && \
        pip install -r requirements/prod.txt -r requirements/dev.txt && \
        pip install --find-links=dist --no-index codeontap-cli

RUN gem install cfn-nag

# change back to standard repo location
USER codeontap

VOLUME /home/hamlet/cmdb
WORKDIR /home/hamlet/cmdb
