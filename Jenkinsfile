#!groovy

def slackColours = [ 'good' : '#50C878', 'bad' : '#B22222', 'info' : '#62B1F6' ]
def slackChannel = '#devops-framework'

pipeline {
    agent {
        label 'codeontaplatest'
    }
    options {
        timestamps()
        durabilityHint('PERFORMANCE_OPTIMIZED')
        quietPeriod(0)
        disableConcurrentBuilds()
        parallelsAlwaysFailFast()
        timeout(time: 6, unit: 'HOURS')
    }


    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'codeontap/gen3'
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
                not {
                    buildingTag()
                }
            }
            steps {
                script {
                    env.CODEONTAP_VERSION = 'master'
                    env.DOCKER_IMAGE_VERSION = "${env['repo']}-${env['commit']}"
                    env.SOURCE_BRANCH = 'master'
                    env.DOCKER_TAG = 'latest'
                }
            }
        }

        stage('Build-Tag-Setup') {
            when {
                allOf {
                    branch 'master'
                    buildingTag()
                }
            }

            steps {
                script {
                    env.CODEONTAP_VERSION = "${env['BRANCH_NAME']}"
                    env.DOCKER_IMAGE_VERSION = "${env['BRANCH_NAME']}"
                    env.SOURCE_BRANCH = "${env['BRANCH_NAME']}"
                    env.DOCKER_TAG = "${env['BRANCH_NAME']}"
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
                            docker image pull "${DOCKER_REPO}:${DOCKER_TAG}"
                        '''

                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-base"  \
                                --build-arg CODEONTAP_VERSION="${CODEONTAP_VERSION}" \
                                -f ./images/stretch/Dockerfile . || exit $?
                        '''
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --no-cache \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}"  \
                                --build-arg CODEONTAP_VERSION="${CODEONTAP_VERSION}" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-base" \
                                -f ./utilities/codeontap/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Base') {
                    when {
                        branch 'master'
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}" || exit $?
                        '''
                    }
                }

                stage('Base-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?
                        '''

                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins" || exit $?
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

                stage('Base-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?
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

            }
        }

        stage('Builder') {
            stages{
                stage('Build-Builder') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}" \
                                -f ./images/stretch/builder/Dockerfile . || exit $?
                        '''


                    }
                }

                stage('Push-Builder') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-builder" || exit $?
                        '''
                    }
                }

                stage('Builder-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Builder-Jenkins') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder" || exit $?
                        '''
                    }
                }

                stage('Builder-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Builder-AzPipeline') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder" || exit $?
                        '''
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
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder" \
                                -f ./images/stretch/builder/meteor/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Builder-Meteor-Base') {
                    when {
                        branch 'master'
                    }

                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" || exit $?
                        '''
                    }
                }


                stage('Builder-Meteor-Jenkins') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache"  \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                -f ./utilities/jenkins/agent-jnlp/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-jenkins-agent-jnlp-builder-meteor-nocache" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Builder-Meteor-Jenkins') {
                    when {
                        branch 'master'
                    }
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker push "${DOCKER_REPO}:${DOCKER_TAG}-jenkins-builder-meteor" || exit $?
                        '''
                    }
                }

                stage('Builder-Meteor-AzPipeline') {
                    steps {
                        sh '''#!/usr/bin/env bash
                            docker build  \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache"  \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-builder-meteor" \
                                -f ./utilities/azure-pipelines/agent/Dockerfile . || exit $?

                            docker build \
                                --cache-from "${DOCKER_REPO}:${DOCKER_TAG}" \
                                -t "${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor" \
                                --build-arg BASE_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}-azpipeline-builder-meteor-nocache" \
                                -f ./images/stretch/builder/meteor/cache-packages/Dockerfile . || exit $?
                        '''
                    }
                }

                stage('Push-Builder-Meteor-AzPipeline') {
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
