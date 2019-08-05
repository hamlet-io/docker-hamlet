# -------------------------------------------------------
# Jenkins JNLP Agent 
# -------------------------------------------------------
ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS jenkins-jnlp-agent

USER root

ARG JENKINSUID=1000
ARG DOCKERGID=497

# Workaround for docker in docker permissions - ECS seems to use 497 for the group Id
RUN useradd -u ${JENKINSUID} --shell /bin/bash --create-home jenkins \
  && groupmod -g "${DOCKERGID}" docker \
  && usermod -G docker jenkins \
  && echo '#Allow Jenkins user to install extra packages' \
  && echo 'jenkins ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

# See https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile#L31
ARG JENKINS_REMOTING_VERSION=3.33
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY scripts/jenkins-jnlp-agent/jenkins-agent /usr/local/bin/jenkins-agent
COPY scripts/jenkins-jnlp-agent/wait-for-it /usr/local/bin/wait-for-it
RUN chmod 755 /usr/local/bin/wait-for-it \
    && chmod 755 /usr/local/bin/jenkins-agent

WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT [ "/usr/local/bin/jenkins-agent"]