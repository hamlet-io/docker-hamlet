# -------------------------------------------------------
# Azure Pipelines Agent Dockerfile
# -------------------------------------------------------
ARG BASE_IMAGE=hamletio/hamlet:latest

FROM ${BASE_IMAGE} AS azpipeline-agent

USER root

ARG PIPELINESUID=1000
ARG DOCKERGID=115

RUN useradd -u ${PIPELINESUID} --shell /bin/bash --create-home azp \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -aG docker azp \
  && usermod -aG sudo azp \
  && echo '%docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  jq \
  git \
  iputils-ping \
  libcurl3 \
  libunwind8 \
  netcat \
  unzip \
  zip \
&& rm -rf /var/lib/apt/lists/*

COPY scripts/azpipelines-agent/start /usr/local/bin/start
RUN chmod 755 /usr/local/bin/start \
  && chmod +x /usr/local/bin/start \
  && chown azp:azp /usr/local/bin/start

WORKDIR /home/azp
USER azp

ENTRYPOINT [ "/usr/local/bin/start" ]
