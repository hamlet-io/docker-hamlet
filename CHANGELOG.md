# Changelog

## Unreleased (2021-06-28)

#### New Features

* add smoke tests for hamlet engine setup
* use the cli engine process for the latest hamlet image
#### Fixes

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

* rebuild and update the docker image container
#### Docs

* update CHANGELOG generation and reduce build churn

Full set of changes: [`8.1.2...56448d2`](https://github.com/hamlet-io/docker-hamlet/compare/8.1.2...56448d2)

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
