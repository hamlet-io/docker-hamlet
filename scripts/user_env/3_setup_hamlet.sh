#!/usr/bin/env bash
set -euo pipefail

HAMLET_ENGINE="${HAMLET_ENGINE:-"tram"}"

# make sure the config dir exists for volume mounts
mkdir -p "${HOME}/.hamlet/config"

# Install and set a default hamlet engine so that things work out of the box
pip install --pre hamlet-cli
hamlet engine install-engine "${HAMLET_ENGINE}"
hamlet engine set-engine "${HAMLET_ENGINE}"

# Basic smoke tests to ensure global engine is working
[[ "$(hamlet engine env GENERATION_DIR)" == "${GENERATION_DIR}" ]] || ( echo "GENERATION_DIR environment variable doesn't match cli expected variable"; exit 255 )
[[ -d "$(hamlet engine env GENERATION_DIR)" ]] || ( echo "No global engine dir found"; exit 255 )
[[ "$(ls -A $(hamlet engine env GENERATION_DIR)))" ]] || ( echo "Global engine dir empty"; exit 255 )
