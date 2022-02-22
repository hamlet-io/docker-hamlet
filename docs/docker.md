# Docker Images

* Project’s docker images use a multi-stage build process to build each of the images
* Each image is defined within its own `Dockerfile`
* The content and intent for each image is outlined below

## base

* the origin base image for all others in the build process
* Installs on the bare minimum that will be used by all other images
* adds hamlet-centric env vars to container
* installs pre-requisite OS, python, npm packages
* clones in hamlet from source
* clones in the hamlet cli

## hamlet

* builds from base
* adds the hamlet user
* adds some quality-of-life updates like styled shell prompt
* Intended for development and production usage - intended for interactive usage
  * link to setting up docker articles

## builder-meteor

* builds from base
* installs [Meteor](https://www.meteor.com/)
* Intended for use in build pipelines - not intended for interactive use

## jenkins

* builds from base
* installs the JNLP agent
* designed to work with container-based cloud agents - not intended for interactive use

## azpipelines

* builds from base
* installs an Azure Pipelines agent
* used for CI/CD within Azure Pipelines - not intended for interactive use
