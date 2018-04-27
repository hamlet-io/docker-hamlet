FROM openjdk:8-jdk

# Install OS Packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    docker \
    dos2unix \
    git \
    jq \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/codeontap/generation && \
    mkdir -p /opt/codeontap/automation && \
    mkdir -p /opt/codeontap/startup && \
    mkdir -p /var/opt/codeontap
    
RUN git clone --depth 1 --branch fix-lb-healthchecklookup https://github.com/roleyfoley/gen3.git /opt/codeontap/generation && \
    git clone --depth 1 https://github.com/roleyfoley/gen3-automation.git /opt/codeontap/automation && \
    git clone --depth 1 https://github.com/roleyfoley/gen3-startup.git /opt/codeontap/startup

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup

ENV ACCOUNT=""
ENV PRODUCT=""
ENV ENVIRONMENT=""
ENV SEGMENT=""

RUN python3 -m pip install awscli --upgrade --no-cache-dir --user

WORKDIR /var/opt/codeontap