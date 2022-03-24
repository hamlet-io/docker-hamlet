#!/usr/bin/env bash
set -euo pipefail

PYENV_ROOT="${PYENV_ROOT:-"${HOME}/.pyenv"}"

git clone --depth 1 https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"

( cd ${PYENV_ROOT} && src/configure && make -C src )

# pyenv install
PYTHON_VERSION=3.9.10
eval "$(pyenv init -)"
pyenv install "${PYTHON_VERSION}"
pyenv global "${PYTHON_VERSION}"
python --version
pip install --upgrade pip
