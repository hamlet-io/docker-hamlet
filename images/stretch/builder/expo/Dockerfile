ARG BASE_IMAGE=codeontap/gen3:latest-stretch-builder

FROM ${BASE_IMAGE} AS expo

ENV TURTLE_VERSION=0.5.12

RUN yarn config set prefix ~/.yarn && \
        yarn global add turtle-cli@$TURTLE_VERSION
