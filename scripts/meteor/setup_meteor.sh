#!/usr/bin/env bash
set -euo pipefail

METEOR_RELEASE="${METEOR_RELEASE:-"1.8.0.1"}"

#Install Meteor
curl https://install.meteor.com/?release=${METEOR_RELEASE} | sh

meteor create --release ${METEOR_RELEASE} --full ${HOME}/dummyapp/src
cd ${HOME}/dummyapp/src && meteor npm install
meteor build ${HOME}/dummyapp/dist --directory
rm -rf ${HOME}/dummyapp
