#!/usr/bin/env bash
set -euo pipefail

# This is a wrapper script which will run all of the user env setup scripts
# These scripts setup tools that are recommended to run within a user home dir or context

user_env_dir="${1:-"/opt/tools/scripts/user_env"}"
echo "Running env_setup for $(id -u)"

for f in ${user_env_dir}/*.sh; do
  echo "Running user env: ${f}"
  bash "$f" || exit $?
done
