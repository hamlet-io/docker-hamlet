#!/usr/bin/env bash

# Override docker latest for git repo latest
HAMLET_VERSION="${HAMLET_VERSION}"
if [[ "${HAMLET_VERSION}" == "latest" ]]; then
    HAMLET_VERSION="master"
fi

# Create the Git clone commands to get the Repositories
# note: original hamlet-io repositories use "master" as default branch
#       whilst the modern approach is to use "main" as default.
#       This checks for the existence of the HAMLET_VERSION branch and
#       if it does not exist, it attempts "main" instead.
jq -r '.Repositories[] | "git ls-remote --heads \(.Repository) \(env.HAMLET_VERSION) && git clone --depth 1 --branch \(env.HAMLET_VERSION) \(.Repository) \(.Directory) || git ls-remote --heads \(.Repository) main && git clone --depth 1 --branch main \(.Repository) \(.Directory)" ' </build/config.json > /build/scripts/clone.sh
chmod u+rwx /build/scripts/clone.sh

# Create the Version file from the config
echo "{}" | jq  '{ "FrameworkVersion" : env.HAMLET_VERSION, "ContainerVersion" : env.DOCKER_IMAGE_VERSION  }' > /opt/hamlet/version.json
