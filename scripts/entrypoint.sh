#!/usr/bin/env bash
set -e

# Set the shim environment variables
. /opt/tools/scripts/shim_setup.sh

exec "$@"
