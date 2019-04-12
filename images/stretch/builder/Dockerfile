ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS builder

# Allow extra packages to be installed during build process
RUN echo '#Allow Jenkins user to install extra packages'
RUN echo 'jenkins ALL = NOPASSWD : /usr/bin/apt-get' >> /etc/sudoers

# Install Basic build requirements
RUN apt-get update && apt-get install -y \
    build-essential \
    libbz2-dev \
    libpq-dev \
    libcurl4-openssl-dev libssl-dev \
	tk-dev \
	libsqlite3-dev \
	python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
        zappa \
        pytest pytest-sugar pytest-django coverage flake8 

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli
