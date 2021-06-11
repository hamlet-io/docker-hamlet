#!/usr/bin/env bash
set -eo pipefail

NODENV_ROOT="${NODENV_ROOT:-"${HOME}/.nodenv"}"

git clone --depth 1 https://github.com/nodenv/nodenv.git "${NODENV_ROOT}"
git clone --depth 1 https://github.com/nodenv/node-build.git "${NODENV_ROOT}/plugins/node-build"
git clone --depth 1 https://github.com/nodenv/node-build-update-defs.git "${NODENV_ROOT}/plugins/node-build-update-defs"

( cd ${NODENV_ROOT} && src/configure && make -C src )

# nodenv install
NODE_VERSION=12.22.1
eval "$(nodenv init -)"
nodenv install "${NODE_VERSION}"
nodenv global "${NODE_VERSION}"
node --version
