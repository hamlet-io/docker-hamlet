ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS builder

# Install Basic build requirements
RUN apt-get update && apt-get install -y \
	make build-essential \
    libbz2-dev libpq-dev \
	libcurl4-openssl-dev libssl-dev libsqlite3-dev\
	zlib1g-dev libbz2-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
	xz-utils tk-dev libffi-dev liblzma-dev libedit-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
        zappa \
        pytest pytest-sugar pytest-django coverage flake8

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli
