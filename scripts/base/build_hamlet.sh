#!/usr/bin/env bash

# Override docker latest for git repo latest
HAMLET_VERSION="${HAMLET_VERSION:-"latest"}"

function clone_repo() {
    local repository_url="$1"; shift
    local local_directory="$1"; shift
    local version="${1}"; shift

    git_ref=""

    if [[ "${version}" == "latest" ]]; then

        if [[ -n "$(git ls-remote --heads ${repository_url} main)" ]]; then
            git_ref="main"
        fi

        if [[ -n "$(git ls-remote --heads ${repository_url} master)" ]]; then
            git_ref="master"
        fi

    else
        git_ref="${version}"
    fi

    echo "repo: ${repository_url}"

    git ls-remote --heads --tags --exit-code ${repository_url} ${git_ref} || return $?
    git clone  --branch "${git_ref}" --depth 1 --single-branch "${repository_url}" "${local_directory}" || return $?
}

# Look through the repos we've been asked for and call clone as required
jq -r '.Repositories[] | "clone_repo \(.Repository) \(.Directory) ${HAMLET_VERSION} || exit $?"' </build/config.json > /build/scripts/clone.sh

chmod u+rwx /build/scripts/clone.sh

. /build/scripts/clone.sh

# Use pypi to install the cli
if [[ "${HAMLET_VERSION}" == "latest" ]]; then
    pip install --pre hamlet-cli
else
    pip install "hamlet-cli=${HAMLET_VERSION}"
fi

# Create the Version file from the config
echo "{}" | jq  '{ "FrameworkVersion" : env.HAMLET_VERSION, "ContainerVersion" : env.DOCKER_IMAGE_VERSION  }' > /opt/hamlet/version.json
