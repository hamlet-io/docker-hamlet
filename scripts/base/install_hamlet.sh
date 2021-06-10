#!/usr/bin/env bash

# Override docker latest for git repo latest
HAMLET_VERSION="${HAMLET_VERSION:-"latest"}"

# make sure the config dir exists for volume mounts
mkdir -p ~/.hamlet/config

# Use pypi to install the cli
if [[ "${HAMLET_VERSION}" == "latest" ]]; then

    pip install --pre hamlet-cli
    hamlet engine install-engine unicycle

    echo "" >> ~/.bashrc
    echo "# hamlet env config" >> ~/.bashrc
    echo 'eval "$(hamlet --engine _global engine env)"' >> ~/.bashrc

else
    pip install hamlet-cli
fi

## Keep the older hamlet install process to make sure we always have a fall back where the user based process hasn't worked
build_state="/build/config.json"

if [[ ! -f "${build_state}" ]]; then
    echo "Installing git based hamlet engine"
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
    jq -r '.Repositories[] | "clone_repo \(.Repository) \(.Directory) ${HAMLET_VERSION} || exit $?"' < ${build_state} > /build/scripts/clone.sh

    chmod u+rwx /build/scripts/clone.sh
    . /build/scripts/clone.sh
else
    echo "git based hamlet engine alredy installed"
fi
