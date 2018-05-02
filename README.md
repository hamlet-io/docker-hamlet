# Codeontap Gen3 Docker Image  

This repo contains the docker build process to create docker containers for the CodeOnTap Gen3 Framework 

# Images 

We currently create the following docker images  

## Base 

- Tag: base

This image is intented to be used for interactive sessions with codeontap where you run the process manually or a process is invoking the container directly 

## Jenkins-Slave 

- Tag: jenkins-slave 

This image is intended to be used as a JNLP slave using a Jenkins Docker plugin (ECS, Docker, Kubernetes). It is based on the jenkins jnlp slave image and has a specifc entry point to ensure that the JNLP agent reports back to the jenkins sever which invoked it 

# Versions 

Each image has the following tags appended to the image tag name ( e.g base-latest)

- latest - The latest codeontap framework commits - Images are built using the development branch of this repo and the master/default branch of each codeontap repository
- stable - The latest tagged release of the codeontap gen3 framework - Images are built using the master branch of this repo
- x.x.x - A specific relase of the codeontap framework - Images are built based on tags on this repo 

# Configuration

This docker contianers main process is to clone specific versions of the codeontap framework repositories. The config.json file sets the repositories to clone and which branches/tags that the container requires. It also sets a framework version in /opt/codeontap/version.json to identify what version of gen3 you are using.
