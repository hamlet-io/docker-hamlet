#!groovy

def slackChannel = '#devops-framework'

pipeline {
    agent {
        label 'hamlet-latest'
    }
    options {
        timeout(time: 6, unit: 'HOURS')
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'hamletio/hamlet'
        DOCKER_API_VERSION = '1.39'
    }

    stages {
        stage('Setup')  {
            stages {
                stage('BaseSetup') {
                    steps {
                        autocancelConsecutiveBuilds()
                        sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
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
                            env.HAMLET_VERSION = 'latest'
                            env.DOCKER_IMAGE_VERSION = "${env['repo']}-${env['commit']}"
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
                        }
                    }
                }

                stage('Notify') {
                    steps {
                        echo "Running build..."
                        echo "Hamlet Version: ${env['HAMLET_VERSION']}"
                        echo "Docker Image Version: ${env['DOCKER_IMAGE_VERSION']}"
                    }
                }
            }
        }

        stage('Base') {
            stages{
                stage('Build-Base') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --no-cache \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-base"  \
                                --build-arg HAMLET_VERSION="${HAMLET_VERSION}" \
                                -f ./images/stretch/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-base" || exit $?
                        '''
                    }
                }

                stage('Build-Base-Hamlet') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg HAMLET_VERSION="${HAMLET_VERSION}" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}"  \
                                -f ./images/stretch/hamlet/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-Hamlet') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}" || exit $?
                        '''
                    }
                }
            }
        }

        stage('Basic-CI-Agents') {
            stages{
                stage('Build-Base-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-jenkins" \
                                -f ./images/stretch/jenkins/agent-jnlp/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Base-Jenkins') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-jenkins" || exit $?
                        '''
                    }
                }

                stage('Build-Base-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline" \
                                -f ./images/stretch/azure-pipelines/agent/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-AzPipeline') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline" || exit $?
                        '''
                    }
                }
            }

            post {
                success {
                    slackSend (
                        message: "*Success* | <${BUILD_URL}|${JOB_NAME}> \n CI Agents - ${env["DOCKER_REPO"]} - ${env["HAMLET_VERSION"]}",
                        channel: "${slackChannel}",
                        color: "#50C878"
                    )
                }
            }
        }

        stage('Builder-Meteor') {
            stages{
                stage('Build-Base-Meteor') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-builder-meteor" \
                                -f ./images/stretch/builder/meteor/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Base-Meteor') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-builder-meteor" || exit $?
                        '''
                    }
                }

                stage('Build-Meteor-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}-builder-meteor" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-jenkins-agent-jnlp-builder-meteor-nocache"  \
                                -f ./images/stretch/jenkins/agent-jnlp/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}-jenkins-agent-jnlp-builder-meteor-nocache" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-jenkins-builder-meteor" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Meteor-Jenkins') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-jenkins-builder-meteor" || exit $?
                        '''
                    }
                }

                stage('Build-Meteor-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}-builder-meteor" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline-builder-meteor-nocache"  \
                                -f ./images/stretch/azure-pipelines/agent/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${HAMLET_VERSION}-base" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline-builder-meteor-nocache" \
                                -t "${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline-builder-meteor" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }
                stage('Push-Meteor-AzPipeline') {
                    when {
                        anyOf{
                            branch 'master'
                            buildingTag()
                        }
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${HAMLET_VERSION}-azpipeline-builder-meteor" || exit $?
                        '''
                    }
                }

            }
        }
    }

    post {
        success {
            slackSend (
                message: "*Success* | <${BUILD_URL}|${JOB_NAME}> \n Image Build - ${env["DOCKER_REPO"]} - ${env["HAMLET_VERSION"]}",
                channel: "${slackChannel}",
                color: "#50C878"
            )
        }
        failure {
            slackSend (
                message: "*Failure* | <${BUILD_URL}|${JOB_NAME}> \n Image Build - ${env["DOCKER_REPO"]} - ${env["HAMLET_VERSION"]}",
                channel: "${slackChannel}",
                color: "#D20F2A"
            )
        }
    }
}
