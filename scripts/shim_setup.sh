#!/usr/bin/env bash

# Set the appropriate shim mode for the engine you are working with
HAMLET_ENGINE_SHIM_MODE="${HAMLET_ENGINE_SHIM_MODE:-"bundled"}"

if [[ "${HAMLET_ENGINE_SHIM_MODE}" == "bundled" ]]; then
    export GENERATION_ENGINE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-core"
    export GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-plugin-azure"
    export GENERATION_WRAPPER_LOCAL_JAVA="false"
    export GENERATION_WRAPPER_SCRIPT_FILE="$HOME/.hamlet/engine/engines/bundled_shim/shim/engine-wrapper/freemarker-wrapper-Linux/bin/freemarker-wrapper"
    export GENERATION_WRAPPER_JAR_FILE=""
    export GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash"
    export GENERATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/cli"
    export AUTOMATION_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation/jenkins/aws"
    export AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/bundled_shim/shim/executor-bash/automation"
fi

if [[ "${HAMLET_ENGINE_SHIM_MODE}" == "local" ]]; then
    export GENERATION_ENGINE_DIR="$HOME/.hamlet/engine/engines/shim/shim/engine-core"
    export GENERATION_PLUGIN_DIRS="$HOME/.hamlet/engine/engines/shim/shim/engine-plugin-aws;$HOME/.hamlet/engine/engines/shim/shim/engine-plugin-azure"
    export GENERATION_WRAPPER_LOCAL_JAVA="true"
    export GENERATION_WRAPPER_SCRIPT_FILE=""
    export GENERATION_WRAPPER_JAR_FILE="$HOME/.hamlet/engine/engines/shim/shim/engine-wrapper/freemarker-wrapper.jar"
    export GENERATION_BASE_DIR="$HOME/.hamlet/engine/engines/shim/shim/executor-bash"
    export GENERATION_DIR="$HOME/.hamlet/engine/engines/shim/shim/executor-bash/cli"
    export AUTOMATION_DIR="$HOME/.hamlet/engine/engines/shim/shim/executor-bash/automation/jenkins/aws"
    export AUTOMATION_BASE_DIR="$HOME/.hamlet/engine/engines/shim/shim/executor-bash/automation"
fi
