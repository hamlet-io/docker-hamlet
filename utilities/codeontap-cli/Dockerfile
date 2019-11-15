ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS codeontap-cli

ARG CODEONTAP_VERSION=master

# Install the codeontap cli Utility
WORKDIR /opt/codeontap-cli/
RUN chmod ugo+rx /opt/codeontap-cli

COPY scripts/codeontap-cli/ /build/scripts/cli/
RUN chmod -R ugo+rwx /build/scripts/cli/

RUN /build/scripts/cli/build_codeontap-cli.sh
