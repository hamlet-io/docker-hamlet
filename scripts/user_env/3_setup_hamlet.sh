#!/usr/bin/env bash
set -euo pipefail

pip install \
    "hamlet>=9.16.0,<10.0.0" \
    "checkov>=2.1.226,<3.0.0" \
    "cfn-lint>=0.65.1,<1.0.0" \
    "diagrams>=0.22.0,<1.0.0"

hamlet engine install-engine bundled_shim
hamlet engine install-engine shim
hamlet engine set-engine "$(hamlet engine get-engine)"

# Smoke tests to ensure we have a base setup in place
[[ "$(hamlet --engine bundled_shim engine env GENERATION_DIR)" == "${GENERATION_DIR}" ]] || ( echo "GENERATION_DIR environment variable doesn't match cli expected variable"; hamlet --engine bundled_shim engine env; echo "Current Env: ${GENERATION_DIR}"; exit 255 )
[[ -d "$(hamlet --engine bundled_shim engine env GENERATION_DIR)" ]] || ( echo "No shim engine dir found"; exit 255 )
ls -A "$(hamlet --engine bundled_shim engine env GENERATION_DIR)" || ( echo "shim engine dir empty"; exit 255 )

[[ -d "$(hamlet --engine shim engine env GENERATION_DIR)" ]] || ( echo "No shim engine dir found"; exit 255 )
ls -A "$(hamlet --engine shim engine env GENERATION_DIR)" || ( echo "shim engine dir empty"; exit 255 )

[[ -d "$(hamlet engine env GENERATION_DIR)" ]] || ( echo "No default engine dir found"; exit 255 )
ls -A "$(hamlet engine env GENERATION_DIR)" || ( echo "default engine dir empty"; exit 255 )

hamlet entrance list-entrances || ( echo "Could not list entrances with call through to engine"; exit 255 )
