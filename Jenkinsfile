#!groovy

def slackColours = [ 'good' : '#50C878', 'bad' : '#B22222', 'info' : '#62B1F6' ]
def slackChannel = '#devops-framework'

pipeline {
    agent {
        label 'hamlet-latest'
    }
    options {
        timestamps()
        durabilityHint('PERFORMANCE_OPTIMIZED')
        quietPeriod(300)
        disableConcurrentBuilds()
        parallelsAlwaysFailFast()
        timeout(time: 6, unit: 'HOURS')
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'hamletio/hamlet'
    }

    stages {
        stage('BaseSetup') {
            steps {
                sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
                sh 'cd "./images/stretch"'
            }
        }

        stage('Build-Base-Setup') {
            when {
                not {
                    buildingTag()
                }
            }
            steps {
                script {
                    env.HAMLET_VERSION = 'master'
                    env.DOCKER_IMAGE_VERSION = "${env['repo']}-${env['commit']}"
                    env.SOURCE_BRANCH = 'master'
                    env.DOCKER_TAG = 'latest'
                }
            }
        }

        stage('Build-Tag-Setup') {
            when {
                buildingTag()
            }

            steps {
                script {
                    env.HAMLET_VERSION = "${env['TAG_NAME']}"
                    env.DOCKER_IMAGE_VERSION = "${env['TAG_NAME']}"
                    env.SOURCE_BRANCH = "${env['BRANCH_NAME']}"
                    env.DOCKER_TAG = "${env['TAG_NAME']}"
                }
            }
        }

        stage('Setup')  {
            steps {
                echo "Runnig build..."
                echo "Hamlet Version: ${env['HAMLET_VERSION']}"
                echo "Docker Image Version: ${env['DOCKER_IMAGE_VERSION']}"
                echo "Source Branch: ${env['SOURCE_BRANCH']}"
                echo "Docker Tag: ${env['DOCKER_TAG']}"
            }
        }

        stage('Base') {
            stages{

                stage('Build-Base') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --no-cache \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-base"  \
                                --build-arg HAMLET_VERSION="${HAMLET_VERSION}" \
                                -f ./images/stretch/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base') {
                    when {
                        branch 'master'
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-base" || exit $?
                        '''
                    }
                }

                stage('Build-Base-Hamlet') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}"  \
                                --build-arg HAMLET_VERSION="${HAMLET_VERSION}" \
                                -f ./images/stretch/hamlet/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-Hamlet') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}" || exit $?
                        '''
                    }
                }

                stage('Build-Base-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" \
                                -f ./images/stretch/jenkins/agent-jnlp/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-Jenkins') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" || exit $?
                        '''
                    }
                }

                stage('Build-Base-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline" \
                                -f ./images/stretch/azure-pipelines/agent/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-AzPipeline') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline" || exit $?
                        '''
                    }
                }

                stage('Build-Base-Meteor') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                -f ./images/stretch/builder/meteor/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-Meteor') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" || exit $?
                        '''
                    }
                }

            }
        }

        stage('Builder-Meteor') {
            stages{

                stage('Build-Meteor-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache"  \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                -f ./images/stretch/jenkins/agent-jnlp/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Meteor-Jenkins') {
                    when {
                        branch 'master'
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" || exit $?
                        '''
                    }
                }

                stage('Build-Meteor-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache"  \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                -f ./images/stretch/azure-pipelines/agent/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Meteor-AzPipeline') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor" || exit $?
                        '''
                    }
                }

            }
        }
    }

    post {
        failure {
            slackSend (
                message: "DockerImageBuild - *${env["DOCKER_REPO"]} - ${env["DOCKER_TAG"]}* - A error occurred during the image build - #${BUILD_NUMBER} (<${BUILD_URL}|Open>)",
                channel: "${slackChannel}",
                color: "${slackColours['bad']}"
            )
        }
        success {
            slackSend (
                message: "DockerImageBuild - *${env["DOCKER_REPO"]} - ${env["DOCKER_TAG"]}* - Was successful - #${BUILD_NUMBER} (<${BUILD_URL}|Open>)",
                channel: "${slackChannel}",
                color: "${slackColours['good']}"
            )
        }
    }
}
