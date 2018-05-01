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

# Clone in codeontap repositories using config.json
RUN mkdir -p /build/scripts
RUN mkdir -p /var/opt/codeontap

COPY scripts/ /build/scripts

RUN chmod -R u+rwx /build/scripts

COPY config.json build/

RUN /build/scripts/build_codeontap.sh

ENV AUTOMATION_BASE_DIR=/opt/codeontap/automation
ENV AUTOMATION_DIR=/opt/codeontap/automation/jenkins/aws
ENV GENERATION_BASE_DIR=/opt/codeontap/generation
ENV GENERATION_DIR=/opt/codeontap/generation/aws
ENV GENERATION_STARTUP_DIR=/opt/codeontap/startup

ENV ACCOUNT=""
ENV PRODUCT=""
ENV ENVIRONMENT=""
ENV SEGMENT=""

RUN python3 -m pip install awscli --upgrade --no-cache-dir

WORKDIR /var/opt/codeontap