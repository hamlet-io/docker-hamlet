#!/usr/bin/env bash

# Override docker latest for git repo latest
HAMLET_VERSION="${HAMLET_VERSION}"
if [[ "${HAMLET_VERSION}" == "latest" ]]; then
    HAMLET_VERSION="master"
fi

# Create the Git clone commands to get the Repositories
jq  -r '.Repositories[] | "git clone --depth 1 --branch \(env.HAMLET_VERSION) \(.Repository) \(.Directory)" ' </build/config.json > /build/scripts/clone.sh
chmod u+rwx /build/scripts/clone.sh

# Create the Version file from the config
echo "{}" | jq  '{ "FrameworkVersion" : env.HAMLET_VERSION, "ContainerVersion" : env.DOCKER_IMAGE_VERSION  }' > /opt/hamlet/version.json
