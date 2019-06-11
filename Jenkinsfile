pipeline {
    agent {
        label 'codeontap'
    }
    options {
        timestamps ()
    }   

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'codeontap/gen3'
    }

    stages {
        stage('setup') { 
           steps {
               sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
               sh 'export DOCKER_TAG="${TAG_NAME:-"master"}"'
           } 
        }
        stage('build') { 
            parallel { 
                stage('stretch') { 
                    steps {
                        sh './images/stretch/hooks/build'
                    }
                }
                stage('alpine') { 
                    steps { 
                        sh './images/apline/hooks/build'
                    }
                }
            }
        }
        stage('push') { 
            parallel {
                stage('stretch') { 
                    steps {
                        sh './images/stretch/hooks/push'
                    }
                }
                stage('alpine') { 
                    steps {
                        sh './images/alpine/hooks/push'
                    }
                }
            }
        }
    }
}