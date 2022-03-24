#!/usr/bin/env bash
set -euo pipefail

RBENV_ROOT="${RBENV_ROOT:-"${HOME}/.rbenv"}"

git clone --depth 1 https://github.com/rbenv/rbenv.git "${RBENV_ROOT}"
git clone --depth 1 https://github.com/rbenv/ruby-build.git "${RBENV_ROOT}/plugins/ruby-build"

( cd ${RBENV_ROOT} && src/configure && make -C src )

# rbenv
RUBY_VERSION=2.7.5
eval "$(rbenv init -)"
rbenv install "${RUBY_VERSION}"
rbenv global "${RUBY_VERSION}"
ruby --version
