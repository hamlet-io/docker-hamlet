#!/usr/bin/env bash
set -eo pipefail

PYENV_ROOT="${PYENV_ROOT:-"${HOME}/.pyenv"}"

git clone --depth 1 https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"

( cd ${PYENV_ROOT} && src/configure && make -C src )
