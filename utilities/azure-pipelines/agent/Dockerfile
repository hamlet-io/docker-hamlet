# -------------------------------------------------------
# Azure Pipelines Agent Dockerfile
# -------------------------------------------------------
ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS azpipeline-agent

USER root

ARG PIPELINESUID=1000
ARG DOCKERGID=497

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${PIPELINESUID} --shell /bin/bash --create-home azpipelines \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -G docker azpipelines \
  && echo '#Allow Azure Pipelines user to install extra packages' \
  && echo 'azpipelines ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu55 \
        libunwind8 \
        netcat \
        zip \
        unzip

WORKDIR /home/azpipelines
COPY scripts/azpipelines-agent/start /home/azpipelines/start
RUN chmod +x /home/azpipelines/start
USER azpipelines

ENTRYPOINT [ "/home/azpipelines/start" ]