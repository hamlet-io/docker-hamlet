#!/usr/bin/env bash
set -euo pipefail

pip install \
    "hamlet>=9.16.0,<10.0.0" \
    "checkov>=2.1.226,<3.0.0" \
    "cfn-lint>=0.65.1,<1.0.0"

hamlet entrance list-entrances || ( echo "Could not list entrances with call through to engine"; exit 255 )
