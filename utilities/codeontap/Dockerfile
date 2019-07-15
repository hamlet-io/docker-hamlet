# Install CodeOnTap

ARG BASE_IMAGE=codeontap/gen3:latest-alpine

FROM ${BASE_IMAGE} AS jenkins-jnlp-agent

ARG CODEONTAP_VERSION=master
ARG DOCKER_IMAGE_VERSION=master

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

# Get CodeOnTap code
RUN chmod -R u+rwx /build/scripts && \
    chmod u+s /build/ && \
    chmod -R ugo+rx /opt/codeontap
 
RUN echo "Cloning images on $(date +%s)"
RUN /build/scripts/build_codeontap.sh && \
    /build/scripts/clone.sh
