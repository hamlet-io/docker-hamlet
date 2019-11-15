#!/usr/bin/env bash

# Override docker latest for git repo latest
CODEONTAP_VERSION="${CODEONTAP_VERSION}"
if [[ "${CODEONTAP_VERSION}" == "latest" ]]; then
    CODEONTAP_VERSION="master"
fi

git clone --depth 1 --branch "${CODEONTAP_VERSION}" https://github.com/codeontap/gen3-cli/ ./

cd gen3-cli
python setup.py bdist_wheel
pip install --no-index --find-links=dist codeontap-cli
