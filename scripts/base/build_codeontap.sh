#!/usr/bin/env bash

# Override docker latest for git repo latest
CODEONTAP_VERSION="${CODEONTAP_VERSION}"
if [[ "${CODEONTAP_VERSION}" == "latest" ]]; then
    CODEONTAP_VERSION="master"
fi

# Create the Git clone commands to get the Repositories
jq  -r '.Repositories[] | "git clone --depth 1 --branch \(env.CODEONTAP_VERSION) \(.Repository) \(.Directory)" ' </build/config.json > /build/scripts/clone.sh
chmod u+rwx /build/scripts/clone.sh

# Create the Version file from the config
echo "{}" | jq  '{ "FrameworkVersion" : env.CODEONTAP_VERSION, "ContainerVersion" : env.DOCKER_IMAGE_VERSION  }' > /opt/codeontap/version.json
