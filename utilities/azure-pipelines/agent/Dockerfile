# -------------------------------------------------------
# Azure Pipelines Agent Dockerfile
# -------------------------------------------------------
ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS azpipeline-agent

USER root

ARG PIPELINESUID=1000
ARG DOCKERGID=497

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${PIPELINESUID} --shell /bin/bash --create-home azp \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -G docker azp \
  && echo '#Allow Azure Pipelines user to install extra packages' \
  && echo 'azp ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

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
RUN chmod 755 /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
WORKDIR /home/azp
USER azp

ENTRYPOINT [ "/usr/local/bin/start" ]