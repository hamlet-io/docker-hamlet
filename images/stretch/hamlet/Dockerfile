# Local development image

ARG BASE_IMAGE=hamletio/hamlet:latest-base

FROM ${BASE_IMAGE} AS hamlet

USER root

# Run Hamlet Support Scripts
COPY scripts/hamlet/ /build/scripts/
RUN chmod u+rx -R /build/scripts

RUN echo "Updating Shell Prompt" && \
    /build/scripts/shellprompt.sh && \
    rm -rf /build

ARG HAMLETUID=1003
RUN useradd -u ${HAMLETUID} --shell /bin/bash --create-home hamlet

# change back to standard repo location
USER hamlet

RUN mkdir /home/hamlet/cmdb && chown hamlet:hamlet /home/hamlet/cmdb

VOLUME /home/hamlet/cmdb
WORKDIR /home/hamlet/cmdb
