ARG BASE_IMAGE=codeontap/gen3:latest

FROM ${BASE_IMAGE} AS codeontap

USER root

ARG COTUID=333

# Install CodeOnTap
ARG CODEONTAP_VERSION=master
ARG DOCKER_IMAGE_VERSION=master

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup
ENV GENERATION_PLUGIN_DIRS=/opt/codeontap/plugins

RUN useradd -u ${COTUID} --shell /bin/bash --create-home codeontap && \
        mkdir /home/codeontap/cmdb

#CMDB Mount point
VOLUME /home/codeontap/cmdb

# Directory set up and file copying
RUN mkdir -p /build/scripts &&  mkdir -p /opt/codeontap && mkdir -p /opt/codeontap/plugins

COPY scripts/base/ /build/scripts/
COPY config.json /build/config.json

# Get CodeOnTap code
RUN chmod -R u+rwx /build/scripts && \
    chmod u+s /build/ && \
    chmod -R ugo+rx /opt/codeontap

RUN echo "Cloning images on $(date +%s)"
RUN /build/scripts/build_codeontap.sh && \
    /build/scripts/clone.sh

# Install the cli
WORKDIR /opt/codeontap/cli/gen3-cli
RUN python setup.py bdist_wheel && \
        python -m pip install -r requirements/dev.txt -r requirements/prod.txt && \
        python -m pip install --no-index --find-links=dist codeontap-cli

RUN gem install cfn-nag

# change back to standard repo location
USER codeontap
WORKDIR /home/codeontap/cmdb
