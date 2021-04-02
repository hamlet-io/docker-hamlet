# [0.0.0](https://github.com/hamlet-io/docker-hamlet/compare/v8.0.1...v0.0.0) (2021-04-02)



## [8.0.1](https://github.com/hamlet-io/docker-hamlet/compare/v8.0.0...v8.0.1) (2021-03-30)


### Bug Fixes

* base bash entrypoint ([eef66b0](https://github.com/hamlet-io/docker-hamlet/commit/eef66b040db32b5baf97553c715fcdc871d45b4c))
* bash script syntax ([747827b](https://github.com/hamlet-io/docker-hamlet/commit/747827bf65987b3a80bd3c68c6a57d879bf13aa8))
* basic exec entrypoint ([b252f79](https://github.com/hamlet-io/docker-hamlet/commit/b252f79528fa3cc98d4245e183032892096f4f00))
* build args ([37c0c8a](https://github.com/hamlet-io/docker-hamlet/commit/37c0c8a7c0458888e64ae5f1a521f86bcd4920a8))
* changelog generation ([27f0a21](https://github.com/hamlet-io/docker-hamlet/commit/27f0a21f5b4d6632ec6bb57d42c60303987f8879))
* docker file and update app langs ([6e3f035](https://github.com/hamlet-io/docker-hamlet/commit/6e3f035d38a0ebf215e4b0e7c7b9378bde3d535b))
* handle git refs during build process ([#34](https://github.com/hamlet-io/docker-hamlet/issues/34)) ([612ccb8](https://github.com/hamlet-io/docker-hamlet/commit/612ccb834a27a12e9e17c95ee4458ded81fa462a))
* image source for build arg ([5d37f0c](https://github.com/hamlet-io/docker-hamlet/commit/5d37f0cf453302a527a45ea7822f09371c103cc0))
* image version id ([697de7d](https://github.com/hamlet-io/docker-hamlet/commit/697de7d39bb208fe9217062041379085b200433f))
* revert change to consecutive build as we already do it ([ffd4102](https://github.com/hamlet-io/docker-hamlet/commit/ffd4102b6a5e1aaf13879e97a02d523cff31acd1))
* supersede builds in the pipeline ([35a4557](https://github.com/hamlet-io/docker-hamlet/commit/35a45577636dd9a2b08dada3681a4e371eda49b6))
* tag pushing policy ([123683d](https://github.com/hamlet-io/docker-hamlet/commit/123683d2b5900b2e52cf2dab744d9ae010c3b5e7))
* update perm on entrypoint ([d2d4d3a](https://github.com/hamlet-io/docker-hamlet/commit/d2d4d3aa9f41dff3cba4c61bbc2016c0ef03dbf6))
* use ref for clone ([27517eb](https://github.com/hamlet-io/docker-hamlet/commit/27517ebd807584f710056d3dec1ae49ed22a8ccf))


### Features

* Include Diagrams Plugin ([#32](https://github.com/hamlet-io/docker-hamlet/issues/32)) ([fc51db2](https://github.com/hamlet-io/docker-hamlet/commit/fc51db2092bcaacbf0b73dd5131ee5d3e102ecc4)), closes [hamlet-io/executor-python#75](https://github.com/hamlet-io/executor-python/issues/75)



# [8.0.0](https://github.com/hamlet-io/docker-hamlet/compare/v7.0.0...v8.0.0) (2021-01-11)


### Bug Fixes

* autocancel builds ([ef8117c](https://github.com/hamlet-io/docker-hamlet/commit/ef8117c544a3d12f5a0529553e0ffea1e4a18b1e))
* cancel consecutive builds ([570b35d](https://github.com/hamlet-io/docker-hamlet/commit/570b35d645afe3763387d596a8d3c811b7b0456d))
* disable consecutive ([1f40db9](https://github.com/hamlet-io/docker-hamlet/commit/1f40db9e47383278f823a91c967848a35e6b9054))
* hamlet cli installation and cli prompt ([e98bf38](https://github.com/hamlet-io/docker-hamlet/commit/e98bf3870b78999677e64f1f62584b5f8db9ef8d))
* jenkins fail on jnlp fail ([2b85bd5](https://github.com/hamlet-io/docker-hamlet/commit/2b85bd5ccd40a59411d900ba7675b13364baa8e2))
* lock docker API version for ECS support ([661e58e](https://github.com/hamlet-io/docker-hamlet/commit/661e58e25059bfc211b26de4974e0dea6fc42edc))
* nodeenv installs and py depdencies ([73281d0](https://github.com/hamlet-io/docker-hamlet/commit/73281d0982d81c39a82c9e59363d864665aa8d2b))
* set docker version for builds ([50cca00](https://github.com/hamlet-io/docker-hamlet/commit/50cca00754de865591329c447c9208acf5b7ebf1))
* update remoting agent for jenkins ([ebf6462](https://github.com/hamlet-io/docker-hamlet/commit/ebf6462879ba890e05b57891dd251580963673a8))
* **azurecli:** move az cli extension dir out of /root ([#30](https://github.com/hamlet-io/docker-hamlet/issues/30)) ([370fb93](https://github.com/hamlet-io/docker-hamlet/commit/370fb93cfc19ec4173a86f7cae4826fd79aec98d))


### Features

* add graphviz to package deps ([532bb81](https://github.com/hamlet-io/docker-hamlet/commit/532bb81cb1fec8612ae0312c48bbcd949bd1c8b9))
* add slack notification on ci build ([#31](https://github.com/hamlet-io/docker-hamlet/issues/31)) ([c76e769](https://github.com/hamlet-io/docker-hamlet/commit/c76e769338aa4594a7158ef0af1e950571d398e1))
* changelog generation ([cdbf2b8](https://github.com/hamlet-io/docker-hamlet/commit/cdbf2b87e058f02f4044a99d73d40b4e1a02655d))
* changelog generation ([c87ba94](https://github.com/hamlet-io/docker-hamlet/commit/c87ba94c3df2488ada12d3ddac0c8f1b9709148a))
* support startup commands as env vars ([#29](https://github.com/hamlet-io/docker-hamlet/issues/29)) ([ef16c52](https://github.com/hamlet-io/docker-hamlet/commit/ef16c5282d1d89dc434cf7b098cbedc36d717920))



# [7.0.0](https://github.com/hamlet-io/docker-hamlet/compare/v6.1.0-rc1...v7.0.0) (2020-04-26)



# [6.1.0-rc1](https://github.com/hamlet-io/docker-hamlet/compare/v6.0.0...v6.1.0-rc1) (2019-12-13)



# [6.0.0](https://github.com/hamlet-io/docker-hamlet/compare/v5.5.8...v6.0.0) (2019-09-09)



## [5.5.8](https://github.com/hamlet-io/docker-hamlet/compare/v5.5.7...v5.5.8) (2019-07-30)



## [5.5.7](https://github.com/hamlet-io/docker-hamlet/compare/v5.5.6...v5.5.7) (2019-06-13)



## [5.4.1](https://github.com/hamlet-io/docker-hamlet/compare/v5.4.0...v5.4.1) (2019-04-12)



