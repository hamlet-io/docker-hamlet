# -------------------------------------------------------
# Base gen3 Image
# -------------------------------------------------------
FROM buildpack-deps:stretch-scm AS gen3

USER root

# Setup PyEnv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHON_VERSION 3.6.9
ENV PYTHON2_VERSION 2.7.16

#Docker user
ARG DOCKERGID=497

# Install OS Packages
RUN apt-get update && apt-get install --no-install-recommends -y \
        # setup apt for different sources
        apt-utils \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common \
        # Standard linux tools
        dos2unix \
        tar zip unzip \
        less vim tree \
        jq \
        groff \
        # Freemarker Req
        openjdk-8-jdk \
        # Python/PyEnv Reqs
        make build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
        libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
        libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
   && rm -rf /var/lib/apt/lists/*

# -- Install extra library packages --
# Add docker to apt-get
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Add Node to apt-get
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -

# Add Yarn to apt-get
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add Backports sources
RUN echo "deb http://deb.debian.org/debian stretch-backports main" | tee /etc/apt/sources.list.d/backports.list
RUN echo 'Package: * \n Pin: release a=stretch-backports \n Pin-Priority: 900' | tee /etc/apt/preferences.d/backports

RUN apt-get update && apt-get install --no-install-recommends -y \
    docker-ce-cli \
    git-lfs \
    nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

# Add docker user for docker bind mount
RUN groupadd -g "${DOCKERGID}" docker

# PyEnv requirements
ENV PYENV_ROOT /usr/local/opt/pyenv
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
RUN ln -s /usr/local/opt/pyenv/bin/pyenv /usr/local/bin/pyenv
ENV PATH="${PYENV_ROOT}/shims:${PATH}"

RUN pyenv install "${PYTHON_VERSION}" && pyenv install "${PYTHON2_VERSION}" && \
        pyenv global "${PYTHON_VERSION}" && python --version && python -m pip install --upgrade --no-cache-dir pip

# Install Python Packages
RUN python -m pip install --upgrade --no-cache-dir \
        setuptools \
        pipenv \
        virtualenv \
        docker-compose \
        PyYAML==3.12 \
        awscli \
        azure-cli \
        requests \
        cookiecutter

# Install NPM Packages
RUN npm install -g \
    yamljs
