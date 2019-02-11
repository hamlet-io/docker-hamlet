# Codeontap Gen3 Docker Image

This repo contains the docker build process to create docker containers for the CodeOnTap Gen3 Framework

## Image Variants

### Base

#### ```codeontap/gen3:<version>```

This is the standard debian stretch based image which will generate and manage codeontap templates

#### ```codeontap/gen3:<version>-builder```

This image is used of building application code as part of a CodeOnTap build process. It should contain the required OS software packages to build and test application code

#### ```codeontap/gen3:<version>-builder-meteor```

An extension for the builder image which but also includes Meteor (https://www.meteor.com/ ) installed along with a pre-cached package repository. *This is only supported on stretch based images*

### CI/CD Tools

The CI/CD Tool images are extensions of the base images with support for a specific CI/CD Tooling service

#### ```codeontap/gen3:<version>-jenkins-<base>```

This image extends the given base image with the Jenkins JNLP based remoting agent installed and configured to run as the entrypoint. This is designed to work with Container based cloud agents.

### OS

OS Variants are available for both base image and CICD images. Tags without the OS specified will use a Debian Stretch based image. Not all images will have all OS images available please check the image variant you are looking for before adding the OS tag.

### ```codeontap/gen3:<version>-stretch-<image>

A Debian stretch based image

### ```codeontap/gen3:<version>-alpine-<image>

A alpine linux based image

## Versions

Each image has the following tags:

- latest - The latest codeontap framework commits - Images are built using the master branch of this repo and the master/default branch of each codeontap repository
- stable - The latest tagged release of the codeontap gen3 framework - Images are built using the train branch of this repo
- x.x.x - A specific release of the codeontap framework - Images are built based on tags on this repo

## Configuration

This docker containers main process is to clone specific versions of the codeontap framework repositories. The config.json file sets the repositories to clone and which branches/tags that the container requires. It also sets a framework version in /opt/codeontap/version.json to identify what version of gen3 you are using.
