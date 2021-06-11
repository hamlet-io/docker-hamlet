#!/usr/bin/env bash
set -euo pipefail

# Install base packages
pip install --upgrade --no-cache-dir \
        setuptools \
        pipenv \
        virtualenv \
        docker-compose \
        PyYAML \
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
