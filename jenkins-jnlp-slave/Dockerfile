FROM codeontap/gen3:latest

USER root

ARG UID=1000

RUN useradd jenkins -u ${UID} --shell /bin/bash --create-home \
    && usermod -a -G docker jenkins 

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

ENTRYPOINT [ "/usr/local/bin/jenkins-slave"]