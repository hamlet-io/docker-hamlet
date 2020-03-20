ARG BASE_IMAGE=hamletio/hamlet:latest-builder-meteor

FROM ${BASE_IMAGE} AS jenkins-jnlp-agent

# Creates an app which forces the local cache to be created
RUN meteor create --release ${METEOR_RELEASE} --full ~/dummyapp/src && cd ~/dummyapp/src && meteor npm install && meteor build ~/dummyapp/dist --directory && rm -rf ~/dummyapp
