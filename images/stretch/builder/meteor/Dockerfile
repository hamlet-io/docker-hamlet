ARG BASE_IMAGE=hamletio/hamlet:latest-builder

FROM ${BASE_IMAGE} AS meteor

USER root

ENV METEOR_RELEASE=1.8.0.1

#Install Meteor
RUN curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER hamlet
