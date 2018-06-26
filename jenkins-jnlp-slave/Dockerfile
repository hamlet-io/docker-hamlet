FROM codeontap/gen3:latest

USER root

RUN useradd jenkins --shell /bin/bash --create-home \
    && usermod -a -G sudo jenkins  \
    && usermod -a -G docker jenkins \
    && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo 'jenkins:secret' | chpasswd

# See https://github.com/jenkinsci/docker-slave/blob/master/Dockerfile#L31
ARG JENKINS_REMOTING_VERSION=3.19
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY scripts/jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 755 /usr/local/bin/jenkins-slave

WORKDIR /home/jenkins
USER jenkins

VOLUME /var/lib/docker

ENV ENABLE_DOCKER=""

ENTRYPOINT [ "/usr/local/bin/jenkins-slave"]