ARG BASE_IMAGE=codeontap/gen3:latest-stretch

FROM ${BASE_IMAGE} AS builder

ENV PYTHON_VERSION=3.6.9

# Install Basic build requirements
RUN apt-get update && apt-get install -y \
	make build-essential \
    libbz2-dev libpq-dev \
	python3-dev \
	libcurl4-openssl-dev libssl-dev libsqlite3-dev\
	zlib1g-dev libbz2-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
	xz-utils tk-dev libffi-dev liblzma-dev python3-openssl libedit-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PYENV_ROOT=/usr/local/opt/pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN ln -s /usr/local/opt/pyenv/bin/pyenv /usr/local/bin/pyenv
ENV PATH="$(pyenv root)/shims:${PATH}"

RUN pyenv install "${PYTHON_VERSION}" && pyenv global "${PYTHON_VERSION}"

# Install Python packages
RUN pip install --no-cache-dir \
		pipenv \
        zappa \
        pytest pytest-sugar pytest-django coverage flake8 

# Install NPM Packages
RUN npm install -g \
    grunt-cli \
    gulp-cli
