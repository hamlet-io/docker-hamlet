ARG BUILD_VERSION=latest

FROM codeontap/gen3:${BUILD_VERSION}-alpine AS base

# Allow extra packages to be installed during build process
RUN echo '#Allow Jenkins user to install extra packages'
RUN echo 'jenkins ALL = NOPASSWD : /usr/bin/apk' >> /etc/sudoers

# Install basic build tools
RUN apk add --no-cache \
    build-base \
    gcc \
    wget \
    curl \
    git \
    postgresql-dev \
    curl-dev \ 
    openssl-dev

# Python based build tools 
RUN apk add --no-cache  \ 
            python3-dev \
    && pip install --no-cache-dir \
            pytest \ 
            pytest-sugar \ 
            pytest-django \
            coverage \
            flake8 \
            zappa

# NPM based build tools
RUN npm install -g \
    grunt-cli \
    gulp-cli    