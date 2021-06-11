#!/usr/bin/env bash
set -euo pipefail

HAMLET_ENGINE="${HAMLET_ENGINE:-"unicycle"}"

# make sure the config dir exists for volume mounts
mkdir -p "${HOME}/.hamlet/config"

pip install --pre hamlet-cli
hamlet engine install-engine ${HAMLET_ENGINE}
hamlet engien set-engine ${HAMLET_ENGINE}
