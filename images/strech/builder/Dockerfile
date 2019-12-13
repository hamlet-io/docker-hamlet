ARG BASE_IMAGE=codeontap/gen3:latest

FROM ${BASE_IMAGE} AS builder

USER root

# Install Basic build requirements
RUN apt-get update && apt-get install -y \
    libpq-dev \
	libcurl4-openssl-dev \
	zlib1g-dev libbz2-dev libsqlite3-dev llvm libncursesw5-dev \
    libedit-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
        zappa \
        pytest pytest-sugar pytest-django coverage flake8

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli

USER codeontap
