#!/usr/bin/env bash
set -euo pipefail

JENV_ROOT="${JENV_ROOT:-"${HOME}/.jenv"}"

git clone --depth 1 https://github.com/jenv/jenv.git "${JENV_ROOT}"

# pyenv install
eval "$(jenv init -)"

jenv add /usr/lib/jvm/temurin-11-jdk-amd64/
jenv add /usr/lib/jvm/temurin-17-jdk-amd64/

jenv doctor
jenv global system
