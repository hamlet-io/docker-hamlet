ARG BASE_IMAGE=hamletio/hamlet:latest-base

FROM ${BASE_IMAGE} AS builder-meteor

USER root

ENV METEOR_RELEASE=1.8.0.1

#Install Meteor
RUN curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

USER hamlet
