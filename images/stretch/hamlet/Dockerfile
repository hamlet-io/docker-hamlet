ARG BASE_IMAGE=hamletio/hamlet:latest-base

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

# Run Hamlet Support Scripts
COPY scripts/hamlet/ /build/scripts/

RUN chmod -R u+rwx /build/scripts

RUN echo "Updating Shell Prompt" && \
    /build/scripts/shellprompt.sh && \
    rm -rf /build

# Install the cli
WORKDIR /opt/hamlet/cli/gen3-cli
RUN python setup.py bdist_wheel && \
        pip install -r requirements/prod.txt -r requirements/dev.txt && \
        pip install --find-links=dist --no-index codeontap-cli

RUN gem install cfn-nag

# change back to standard repo location
USER hamlet

VOLUME /home/hamlet/cmdb
WORKDIR /home/hamlet/cmdb
