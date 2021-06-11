#!/usr/bin/env bash
set -eo pipefail

RBENV_ROOT="${RBENV_ROOT:-"${HOME}/.rbenv"}"

git clone --depth 1 https://github.com/rbenv/rbenv.git "${RBENV_ROOT}"
git clone --depth 1 https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"

( cd ${RBENV_ROOT} && src/configure && make -C src )
