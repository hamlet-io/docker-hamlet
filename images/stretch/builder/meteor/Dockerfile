ARG BASE_IMAGE=codeontap/gen3:latest-stretch-builder

FROM ${BASE_IMAGE} AS meteor

USER root

ENV METEOR_RELEASE=1.8.0.1

#Install Meteor
RUN curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh
