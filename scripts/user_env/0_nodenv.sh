#!/usr/bin/env bash
set -eo pipefail

NODENV_ROOT="${NODENV_ROOT:-"${HOME}/.nodenv"}"

# Base nodenv and a couple of plugins to handle global packages and manage installations
git clone --depth 1 https://github.com/nodenv/nodenv.git "${NODENV_ROOT}"
git clone --depth 1 https://github.com/nodenv/node-build.git "${NODENV_ROOT}/plugins/node-build"
git clone --depth 1 https://github.com/nodenv/node-build-update-defs.git "${NODENV_ROOT}/plugins/node-build-update-defs"
git clone --depth 1 https://github.com/nodenv/nodenv-package-rehash.git "${NODENV_ROOT}/plugins/nodenv-package-rehash"
git clone --depth 1 https://github.com/nodenv/nodenv-default-packages.git "${NODENV_ROOT}/plugins/nodenv-default-packages"

( cd ${NODENV_ROOT} && src/configure && make -C src )

# install package managers in all nodenv versions
echo "npm" >> "${NODENV_ROOT}/default-packages"
echo "yarn" >> "${NODENV_ROOT}/default-packages"

# nodenv install
NODE_VERSION=12.22.1
eval "$(nodenv init -)"
nodenv install "${NODE_VERSION}"
nodenv global "${NODE_VERSION}"
node --version

nodenv package-hooks install --all
