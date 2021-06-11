#!/usr/bin/env bash
set -euo pipefail

# nodenv install
NODE_VERSION=12.22.1
eval "$(nodenv init -)"
nodenv install "${NODE_VERSION}"
nodenv global "${NODE_VERSION}"
node --version

# pyenv install
PYTHON_VERSION=3.8.8
eval "$(pyenv init -)"
pyenv install "${PYTHON_VERSION}"
pyenv global "${PYTHON_VERSION}"
python --version
pip install --upgrade pip

# rbenv
RUBY_VERSION=2.7.2
eval "$(rbenv init -)"
rbenv install "${RUBY_VERSION}"
rbenv global "${RUBY_VERSION}"
ruby --version

# Install base packages
pip install --upgrade --no-cache-dir \
        setuptools \
        pipenv \
        virtualenv \
        docker-compose \
        PyYAML \
        awscli \
        azure-cli \
        requests \
        zappa \
        pytest \
        pytest-sugar \
        pytest-django \
        coverage \
        flake8

# Install Global NPM Packages
npm install -g \
        yarn
