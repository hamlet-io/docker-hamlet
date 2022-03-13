#!/usr/bin/env bash
set -euo pipefail

# deploy cli tools
pip install --upgrade --no-cache-dir \
        awscli \
        azure-cli

# Az extension installs
az extension add --name front-door
