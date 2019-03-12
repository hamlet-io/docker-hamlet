ARG BASE_IMAGE=codeontap/gen3:latest-stretch-builder

FROM ${BASE_IMAGE} AS expo

ENV TURTLE_VERSION=0.5.12
ENV EXPO_VERSION=2.11.6

RUN yarn global add --prefix /usr/local \
        expo-cli@${EXPO_VERSION} \
        turtle-cli@${TURTLE_VERSION}

COPY ./publish /publish

WORKDIR /app