# Hamlet Docker Image

This repo contains the docker build process to create docker containers for the Hamlet Deployment Framework

## Image Variants

### Base

#### ```hamletio/hamlet:<version>```

This is the standard debian buster based image which will generate and manage hamlet templates

#### ```hamletio/hamlet:<version>-builder```

This image is used of building application code as part of a hamlet build process. It should contain the required OS software packages to build and test application code

#### ```hamletio/hamlet:<version>-builder-meteor```

An extension for the builder image which but also includes Meteor (https://www.meteor.com/ ) installed along with a pre-cached package repository. *This is only supported on buster based images*

### CI/CD Tools

The CI/CD Tool images are extensions of the base images with support for a specific CI/CD Tooling service

#### ```hamletio/hamlet:<version>-jenkins-<base>```

This image extends the given base image with the Jenkins JNLP based remoting agent installed and configured to run as the entrypoint. This is designed to work with Container based cloud agents.

## Versions

Each image has the following tags:

- latest - The latest hamlet framework commits - Images are built using the master branch of this repo and the master/default branch of each hamlet repository
- x.x.x - A specific release of the hamlet framework - Images are built based on tags on this repo

## Configuration

This docker containers main process is to clone specific versions of the hamlet framework repositories. The config.json file sets the repositories to clone and which branches/tags that the container requires. It also sets a framework version in /opt/hamlet/version.json to identify what version of gen3 you are using.
