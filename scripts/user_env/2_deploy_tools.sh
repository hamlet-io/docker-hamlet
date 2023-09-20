#!/usr/bin/env bash
set -euo pipefail

# Add python tooling
pip install --upgrade --no-cache-dir azure-cli virtualenv pytest

# Az extension installs
az extension add --name front-door
