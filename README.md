# Codeontap Gen3 Docker Image

This repo contains the docker build process to create docker containers for the CodeOnTap Gen3 Framework

## Images

We currently create the following docker images which are hosted on dockerhub https://dockerhub.com/r/codeontap/gen3

### gen3

The gen3 is our based image and contains the baseline requirements for running codeontap

**Tag:** gen3

### Jenkins Agents

CodeOnTap mostly runs on a Jenkins instance and we use JNLP based agents. These Docker images are used for container based agents deployed using an appropriate plugin ( ECS, Docker or Kubernetes). It is based on the jenkins jnlp agent and has a specific entry point script suitable for the plugins.

#### jenkins-jnlp-agent

**Tag:** jenkins-jnlp-agent

A standard agent with some basic build tools include for node, python and java based builds

#### jenkins-jnlp-meteor-agent

**Tag:** jenkins-jnlp-meteor-agent

The standard image along with meteor.js. This also includes precached node and meteor modules as they can take some time to download

## Versions

Each image has the following tags:

- latest - The latest codeontap framework commits - Images are built using the master branch of this repo and the master/default branch of each codeontap repository
- stable - The latest tagged release of the codeontap gen3 framework - Images are built using the train branch of this repo
- x.x.x - A specific release of the codeontap framework - Images are built based on tags on this repo

## Configuration

This docker containers main process is to clone specific versions of the codeontap framework repositories. The config.json file sets the repositories to clone and which branches/tags that the container requires. It also sets a framework version in /opt/codeontap/version.json to identify what version of gen3 you are using.
