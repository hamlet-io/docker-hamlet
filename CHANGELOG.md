# Changelog

## Unreleased (2023-09-21)

#### New Features

* add jenv support and jdk8/11 installs
* migrate to java11 for jenkins agents
#### Fixes

* update github action steps
* JENV in the az agent
* jenkins agent entrypoint
* docker hub tokens
* libcurl update for azpipeline
* cd updates for new stage names
#### Refactorings

* migrate to ghcr for hosting ([#77](https://github.com/hamlet-io/docker-hamlet/issues/77))
* general updates to the hamlet image
* remove tools that are required for base

Full set of changes: [`8.5.2, 8.7.0...b34468d`](https://github.com/hamlet-io/docker-hamlet/compare/8.5.2, 8.7.0...b34468d)

## 8.5.2, 8.7.0 (2022-03-25)

#### Fixes

* shim setup env config
#### Others

* changelog bump ([#69](https://github.com/hamlet-io/docker-hamlet/issues/69))

Full set of changes: [`8.5.1...8.5.2, 8.7.0`](https://github.com/hamlet-io/docker-hamlet/compare/8.5.1...8.5.2, 8.7.0)

## 8.5.1 (2022-03-25)

#### New Features

* add support for bundled and local shims
#### Fixes

* relax the set commands used in bash scripts
* update shell for jenkins agent ([#72](https://github.com/hamlet-io/docker-hamlet/issues/72))

Full set of changes: [`8.5.0...8.5.1`](https://github.com/hamlet-io/docker-hamlet/compare/8.5.0...8.5.1)

## 8.5.0 (2022-03-14)

#### New Features

* support changes to the cli with the shim engine
#### Fixes

* default to cli defined default engine

Full set of changes: [`8.4.2...8.5.0`](https://github.com/hamlet-io/docker-hamlet/compare/8.4.2...8.5.0)

## 8.4.2 (2022-02-22)

#### Fixes

* hamlet engine install
* ignore meteor certificate issues ([#68](https://github.com/hamlet-io/docker-hamlet/issues/68))
* match npm version to node version
#### Refactorings

* Ignore dockerhub login for PRs
#### Docs

* move docs for docker image from docs site
#### Others

* changelog bump ([#65](https://github.com/hamlet-io/docker-hamlet/issues/65))

Full set of changes: [`8.2.4...8.4.2`](https://github.com/hamlet-io/docker-hamlet/compare/8.2.4...8.4.2)

## 8.2.4 (2021-07-16)

#### Others

* changelog bump ([#64](https://github.com/hamlet-io/docker-hamlet/issues/64))

Full set of changes: [`8.2.3...8.2.4`](https://github.com/hamlet-io/docker-hamlet/compare/8.2.3...8.2.4)

## 8.2.3 (2021-07-09)

#### New Features

* align engine handling with offical release
* default to unicycle builds on schedules
#### Fixes

* testing for handling explicit set engine vs global
* add suffic on latest tags
* output type
#### Others

* changelog bump ([#59](https://github.com/hamlet-io/docker-hamlet/issues/59))

Full set of changes: [`8.2.2...8.2.3`](https://github.com/hamlet-io/docker-hamlet/compare/8.2.2...8.2.3)

## 8.2.2 (2021-07-09)

#### Fixes

* tag tigger for push

Full set of changes: [`8.2.1...8.2.2`](https://github.com/hamlet-io/docker-hamlet/compare/8.2.1...8.2.2)

## 8.2.1 (2021-07-07)

#### Fixes

* add tag trigger for ci build process ([#60](https://github.com/hamlet-io/docker-hamlet/issues/60))

Full set of changes: [`8.2.0...8.2.1`](https://github.com/hamlet-io/docker-hamlet/compare/8.2.0...8.2.1)

## 8.2.0 (2021-07-07)

#### New Features

* rename bin file to align with executor updates
* add smoke tests for hamlet engine setup
* use the cli engine process for the latest hamlet image
#### Fixes

* use dockerhub login
* schedule tag
* remove build arg
* docker base tag
* (ci): create draft PR for changelog generation
* set default engine to tram
* remove docker layer caching
* changelog typo
* workflow syntax and name
* include plugins for global node packages
* minor updates
* schedule and path for meteor
* docs and cache control
* remove filter on tag
#### Refactorings

* docker build tagging
* hamlet cli and engine management
* rebuild and update the docker image container
#### Docs

* update CHANGELOG generation and reduce build churn
#### Others

* changelog bump ([#54](https://github.com/hamlet-io/docker-hamlet/issues/54))
* (ci): fix description on step name

Full set of changes: [`8.1.2...8.2.0`](https://github.com/hamlet-io/docker-hamlet/compare/8.1.2...8.2.0)

## 8.1.2 (2021-05-13)

#### New Features

* include cmdb plugin ([#39](https://github.com/hamlet-io/docker-hamlet/issues/39))
* Include Diagrams Plugin ([#32](https://github.com/hamlet-io/docker-hamlet/issues/32))
* changelog generation
* changelog generation
* add graphviz to package deps
* add slack notification on ci build ([#31](https://github.com/hamlet-io/docker-hamlet/issues/31))
* support startup commands as env vars ([#29](https://github.com/hamlet-io/docker-hamlet/issues/29))
#### Fixes

* update readme to align with image details
* bash syntax
* hamlet cli install ([#37](https://github.com/hamlet-io/docker-hamlet/issues/37))
* repo url in changelog
* docker file and update app langs
* use ref for clone
* revert change to consecutive build as we already do it
* supersede builds in the pipeline
* image version id
* build args
* bash script syntax
* image source for build arg
* handle git refs during build process ([#34](https://github.com/hamlet-io/docker-hamlet/issues/34))
* update perm on entrypoint
* basic exec entrypoint
* base bash entrypoint
* tag pushing policy
* changelog generation
* update remoting agent for jenkins
* nodeenv installs and py depdencies
* disable consecutive
* autocancel builds
* cancel consecutive builds
* (azurecli): move az cli extension dir out of /root ([#30](https://github.com/hamlet-io/docker-hamlet/issues/30))
* jenkins fail on jnlp fail
* lock docker API version for ECS support
* set docker version for builds
* hamlet cli installation and cli prompt
#### Refactorings

* remove executor-cookiecutter repo
* install hamlet-cli via pip
* remove startup script repo
#### Others

* (deps): bump lodash from 4.17.20 to 4.17.21 ([#43](https://github.com/hamlet-io/docker-hamlet/issues/43))
* (deps): bump hosted-git-info from 2.8.8 to 2.8.9 ([#42](https://github.com/hamlet-io/docker-hamlet/issues/42))
* (deps): bump hosted-git-info from 2.8.8 to 2.8.9 ([#42](https://github.com/hamlet-io/docker-hamlet/issues/42))
* (deps): bump handlebars from 4.7.6 to 4.7.7 ([#41](https://github.com/hamlet-io/docker-hamlet/issues/41))
* changelog
* changelog
* changelog
