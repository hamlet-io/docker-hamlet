pipeline {
    agent {
        label 'codeontap'
    }
    options {
        timestamps ()
    }   

    parameters {
        string(name: 'TAG', defaultValue: 'latest', description: 'Which tag would you like to build?')
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'codeontap/gen3'
        DOCKER_TAG = "${param.TAG ?: 'latest'}"
    }

    stages {
        stage('setup') { 
           steps {
               sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
               script { 
                    env.SOURCE_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                    env.SOURCE_BRANCH = sh(returnStdout: true, script: "echo ${env.GIT_BRANCH} | cut -d / -f 2").trim()
               }
           } 
        }
        stage('image build') { 
            parallel { 
                stage('stretch') { 
                    stages {
                        stage('build') {
                            steps {
                                sh '''
                                    cd "./images/stretch"
                                    ./hooks/build
                                '''
                            }
                        }
                        stage('push') { 
                            steps {
                                sh './images/stretch/hooks/push'
                            }
                        }
                    }
                }
                stage('alpine') { 
                    stages {
                        stage('build') {
                            steps {
                                sh '''
                                    cd "./images/alpine"
                                    ./hooks/build
                                '''
                            }
                        }
                        stage('push') { 
                            steps {
                                sh './images/alpine/hooks/push'
                            }
                        }
                    }
                }
            }
        }
    }
}