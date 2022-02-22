#!/usr/bin/env bash
set -euo pipefail

pip install "hamlet-cli>=9.1.1,<10.0.0"

# Setup a base engine to get things going
hamlet engine install-engine "${HAMLET_ENGINE:-"train"}"

# Snoke tests to ensure we have a base setup in place
[[ "$(hamlet --engine _global engine env GENERATION_DIR)" == "${GENERATION_DIR}" ]] || ( echo "GENERATION_DIR environment variable doesn't match cli expected variable"; hamlet engine env; echo "Current Env: ${GENERATION_DIR}"; exit 255 )
[[ -d "$(hamlet --engine _global engine env GENERATION_DIR)" ]] || ( echo "No global engine dir found"; exit 255 )
ls -A $(hamlet --engine _global engine env GENERATION_DIR) || ( echo "Global engine dir empty"; exit 255 )

[[ -d "$(hamlet engine env GENERATION_DIR)" ]] || ( echo "No default engine dir found"; exit 255 )
ls -A $(hamlet engine env GENERATION_DIR) || ( echo "default engine dir empty"; exit 255 )

hamlet entrance list-entrances || ( echo "Could not list entrances with call through to engine"; exit 255 )
