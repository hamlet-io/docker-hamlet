# Hamlet Deploy Docker Image

This repo contains the docker build process to create docker containers for the Hamlet Deploy application.

For more information see https://docs.hamlet.io

## Image Variants

### Base

#### ```hamletio/hamlet:<version>```

This is the standard debian buster based image with Hamlet Deploy installed and preconfigured.

#### ```hamletio/hamlet:<version>-builder```

This image is used of building application code as part of a Hamlet Deploy build process. It should contain the required OS software packages to build and test application code

#### ```hamletio/hamlet:<version>-builder-meteor```

An extension for the builder image which but also includes Meteor (https://www.meteor.com/ ) installed along with a pre-cached package repository. *This is only supported on buster based images*

### CI/CD Tools

The CI/CD Tool images are extensions of the base images with support for a specific CI/CD Tooling service

#### ```hamletio/hamlet:<version>-jenkins-<base>```

This image extends the base image with the Jenkins JNLP based remoting agent installed and configured to run as the entrypoint. This is designed to work with container-based cloud agents.

## Versions

Each image has the following tags:

- latest - the latest version of Hamlet Deploy - Images are built using the master/main branch of this repo and the master/default branch of each component of the Hamlet Deploy application
- x.x.x - A specific release of the Hamlet Deploy framework - Images are built based on tags on this repo

You can identify the version for a given container by reviewing the _/opt/hamlet/version.json_ file.

```bash
cat /opt/hamlet/version.json
```

## Configuration

This docker containers main process is to clone specific versions of the Hamlet Deploy repositories. The _./config.json_ file determines which repositories to clone and their unique branch/tags.