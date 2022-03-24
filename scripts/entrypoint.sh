#!/usr/bin/env bash
set -euo pipefail

# Set the shim environment variables
. /opt/tools/scripts/shim_setup.sh

exec "$@"
