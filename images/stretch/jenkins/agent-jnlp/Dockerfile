# -------------------------------------------------------
# Jenkins JNLP Agent
# -------------------------------------------------------
ARG BASE_IMAGE=hamletio/hamlet:latest-base

FROM ${BASE_IMAGE} AS jenkins-jnlp-agent

USER root

ARG JENKINSUID=1000
ARG DOCKERGID=497

ENV DOCKER_API_VERSION=1.39

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${JENKINSUID} --shell /bin/bash --create-home jenkins \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -G docker jenkins \
  && echo '#Allow Jenkins user to install extra packages' \
  && echo 'jenkins ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

# See https://github.com/jenkinsci/docker-inbound-agent/blob/master/jenkins-agent
ARG JENKINS_REMOTING_VERSION=4.5
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_REMOTING_VERSION}/remoting-${JENKINS_REMOTING_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar

COPY scripts/jenkins-jnlp-agent/jenkins-agent /usr/local/bin/jenkins-agent
COPY scripts/jenkins-jnlp-agent/wait-for-it /usr/local/bin/wait-for-it
RUN chmod 755 /usr/local/bin/wait-for-it \
    && chmod 755 /usr/local/bin/jenkins-agent

WORKDIR /home/jenkins
USER jenkins
# Create the workspace directory so we can mount volumes to it and maintain user permissions
RUN mkdir -p /home/jenkins/workspace

RUN echo "Setting up hamlet on $(date +%s)" && \
	/build/scripts/install_hamlet.sh

ENTRYPOINT [ "/usr/local/bin/jenkins-agent"]
