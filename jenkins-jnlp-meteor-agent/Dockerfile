FROM codeontap/gen3-jenkins-slave:latest

USER root

ENV METEOR_RELEASE=1.8.0.1

#Install Meteor
RUN curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER jenkins

# Creates an app which forces the local cache to be created
RUN meteor create --release ${METEOR_RELEASE} --full ~/dummyapp/src && cd ~/dummyapp/src && meteor npm install && meteor build ~/dummyapp/dist --directory && rm -rf ~/dummyapp
