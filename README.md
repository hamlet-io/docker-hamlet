# Hamlet Deploy Docker Image

Ths repo contains the docker image build process for the Hamlet Deploy CI Container. The container includes the required dependencies for hamlet along with a CI build environment for common languages used in cloud native applications, Python, Ruby and NodeJS.

For more information on hamlet see https://docs.hamlet.io

## Shim engines

The docker container supports a shim style engine that provides a fixed set of directory locations symlinked to the current default engine.
This is used when you are calling the bash executor commands directly instead of using the hamlet cli commands and would like to manage the engine version through the cli.

The standard engine environment variables are set within the docker container to support this as soon as you start the container up.

To support the migration from using the local java installation to a bundled installation there are two shim modes available, the bundled and the local shims.

If you are planning on using a version of hamlet before 8.5.0 make sure to set the shim mode to the local shim. For any versions above 8.5.0 you can leave the mode as the bundled mode.

To configure the mode set the environment variable `HAMLET_ENGINE_SHIM_MODE` to either `local` or `bundled` as part of the containers startup environment variables

## Image Variants

### Base

#### ```hamletio/hamlet:<version>```

This is our base docker image which includes all the requirements for running hamlet and build tooling. This image can be used as a general purpose CI image
The image also includes common application runtimes for application builds

- python (pyenv for version management)
- node (nodenv for version management)

### Pipeline Agents

The Pipeline agent images are extensions of the base images with support for running as a pipeline agent

#### ```hamletio/hamlet:<version>-jenkins-<base>```

This image extends the base image with the Jenkins JNLP based remoting agent installed and configured to run as the entrypoint. This is designed to work with container-based cloud agents.

#### ```hamletio/hamlet:<version>-azpipeline-<base>```

This image extends the base image with the Azure Pipelines agent, this allows for the use of container based agents for local builds

## Versions

The versions of the docker image do not reflect the latest version of hamlet. The installation of the hamlet cli will be the latest at the time of build for the container. The cli then manages the installation of the engine parts of hamlet deploy.
The image does include caches of the latest engine to get you up and running

The `latest` tag is the latest build of this repository and we will generate regular tagged updates this container with changes included in the [CHANGELOG](./CHANGELOG.md)
