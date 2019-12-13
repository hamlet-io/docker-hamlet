#!groovy

def slackColours = [ 'good' : '#50C878', 'bad' : '#B22222', 'info' : '#62B1F6' ]
def slackChannel = '#devops-framework'

pipeline {
    agent {
        label 'codeontaplatest'
    }
    options {
        timestamps ()
        durabilityHint('PERFORMANCE_OPTIMIZED')
        buildDiscarder(
            logRotator(numToKeepStr: '20')
        )
        quietPeriod(30)
    }

    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'ref',    value: '$.ref'],
                [key: 'repo',   value: '$.repository.full_name' ],
                [key: 'commit', value: '$.after']
            ],
            genericHeaderVariables: [
                [key: 'X-GitHub-Event', regexpFilter: 'push']
            ],
            causeString: "Push event trigger",
            token: '14741357d69c4c5b767e538b495c1363',
            printContributedVariables: false,
            printPostContent: false,
            silentResponse: true,

            regexpFilterText: '$ref',
            regexpFilterExpression: '^refs/(heads|tags)/(master|v.*)'
        )
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'codeontap/gen3'
    }

    parameters {
        string(name: 'ref', defaultValue: '/ref/heads/master', description: "The git ref to use for build" )
        string(name: 'repo', defaultValue: 'codeontap/docker-gen3', description: "The git repo" )
        string(name: 'commit', defaultValue: '', description: "The tirgger commit")
    }

    stages {

        stage('Webhook-Process') {
            steps {
                script {
                    env['TAG'] = ("${env['ref']}".split('/'))[2]
                }

                echo "My Tag is ${env['TAG']}"
            }
        }

        stage('Imaage build') {
            when {
                anyOf {
                    allOf{
                        environment name: 'TAG', value: 'master'
                    }
                    allOf{
                        not {
                            environment name: 'TAG', value: 'master'
                        }
                        environment name: 'repo', value: 'codeontap/docker-gen3'
                    }
                }
            }

            stages {
                stage('BaseSetup') {
                    steps {

                        sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
                        sh 'cd "./images/stretch"'
                    }
                }

                stage('Build-Latest-Setup') {
                    when {
                        environment name: 'TAG', value: 'master'
                    }
                    steps {
                        script {
                            env.CODEONTAP_VERSION = "${env['repo']}-${env['commit']}"
                            env.DOCKER_IMAGE_VERSION =   sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                            env.SOURCE_BRANCH = 'master'
                            env.DOCKER_TAG = 'latest'
                        }
                    }
                }

                stage('Build-Tag-Setup') {
                    when {
                        not {
                            environment name: 'TAG', value: 'master'
                        }
                    }

                    steps {
                        script {
                            env.CODEONTAP_VERSION = "${env['TAG']}"
                            env.DOCKER_IMAGE_VERSION = "${env['TAG']}"
                            env.SOURCE_BRANCH = "${env['TAG']}"
                            env.DOCKER_TAG = "${env['TAG']}"
                        }
                    }
                }

                stage('Setup')  {
                    steps {
                        echo "Runnig build..."
                        echo "CodeOnTap Version: ${env['CODEONTAP_VERSION']}"
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
                                        -t "${DOCKER_REPO}:${DOCKER_TAG}-base"  \
                                        -f ./images/stretch/Dockerfile . || exit $?

                                    docker build \
                                        --no-cache \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-nocli" \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG}-nocli"  \
                                        --build-arg CODEONTAP_VERSION="${CODEONTAP_VERSION}" \
                                        --build-arg DOCKER_IMAGE_VERSION="${DOCKER_IMAGE_VERSION}" \
                                        --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                        -f ./utilities/codeontap/Dockerfile . || exit $?

                                    docker build \
                                        --no-cache \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG%-*}" \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG}"  \
                                        --build-arg CODEONTAP_VERSION="${CODEONTAP_VERSION}" \
                                        --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-nocli" \
                                        -f ./utilities/codeontap-cli/Dockerfile . || exit $?
                                '''

                                sh '''#!/usr/bin/env bash
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG}-base" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG}-nocli" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-nocli" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG}" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}" || exit $?
                                '''
                            }
                        }
                        stage('Base-Agents') {
                            failFast true
                            parallel {
                                stage('Base-Jenkins') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins" || exit $?
                                        '''
                                    }
                                }

                                stage('Base-AzPipeline') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline" || exit $?
                                        '''
                                    }
                                }
                            }
                        }
                    }
                }

                stage('Builder') {
                    stages{
                        stage('Build-Builder') {
                            steps {
                                sh '''#!/usr/bin/env bash
                                    docker build \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-builder" \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                        --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                        -f ./images/stretch/builder/Dockerfile . || exit $?
                                '''

                                sh '''#!/usr/bin/env bash
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG}-builder" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-builder" || exit $?
                                '''
                            }
                        }
                        stage('Builder-Agents') {
                            failFast true
                            parallel {
                                stage('Builder-Jenkins') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins-builder" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins-builder" || exit $?
                                        '''
                                    }
                                }

                                stage('Builder-AzPipeline') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline-builder" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline-builder" || exit $?
                                        '''
                                    }
                                }
                            }
                        }

                        stage('Notify') {
                            steps{
                                slackSend (
                                    message: "DockerImageBuild - *${env["DOCKER_REPO"]} - ${env["DOCKER_TAG"]}* - Builder Image Pushed - #${BUILD_NUMBER} (<${BUILD_URL}|Open>)",
                                    channel: "${slackChannel}",
                                    color: "${slackColours['good']}"
                                )
                            }
                        }
                    }
                }

                stage('Builder-Meteor') {
                    stages{
                        stage('Builder-Metoer-Base') {
                            steps {
                                sh '''#!/usr/bin/env bash
                                    docker build \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-builder-meteor" \
                                        -t "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                        --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                        -f ./images/stretch/builder/meteor/Dockerfile . || exit $?
                                '''

                                sh '''#!/usr/bin/env bash
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" || exit $?
                                    docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-builder-meteor" || exit $?
                                '''
                            }
                        }
                        stage('Builder-Meteor-Agents') {
                            failFast true
                            parallel {
                                stage('Jenkins') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build  \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache"  \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?

                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins-builder-meteor" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache" \
                                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-jenkins-builder-meteor" || exit $?
                                        '''
                                    }
                                }

                                stage('AzPipeline') {
                                    steps {
                                        sh '''#!/usr/bin/env bash
                                            docker build  \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache"  \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?

                                            docker build \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline-builder-meteor" \
                                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor" \
                                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache" \
                                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                                        '''

                                        sh '''#!/usr/bin/env bash
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor" || exit $?
                                            docker push "${DOCKER_REPO}:${DOCKER_TAG%-*}-azpipeline-builder-meteor" || exit $?
                                        '''
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            slackSend (
                message: "DockerImageBuild - *${env["DOCKER_REPO"]} - ${env["DOCKER_TAG"]}* - A error occurred during the iamge build - #${BUILD_NUMBER} (<${BUILD_URL}|Open>)",
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
