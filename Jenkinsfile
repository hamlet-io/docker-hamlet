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
    }   
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_REPO = 'codeontap/gen3'
    }

    parameters { 
        string(name: 'TAG', defaultValue: 'latest', description: "The ${env["DOCKER_REPO"]} git tag to build with" )
    }

    stages {
        stage('setup') { 
           steps {
               sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
               script { 
                    env.SOURCE_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                    env.SOURCE_BRANCH = sh(returnStdout: true, script: "echo ${env.GIT_BRANCH} | cut -d / -f 2").trim()
                    env.DOCKER_TAG = "${params.TAG}"
               }
           } 
        }

        stage('Image - build') {
            steps {
                sh '''
                    cd "./images/stretch"
                    ./hooks/build
                '''
            }
        }

        stage('Image - push') { 
            steps {
                sh './images/stretch/hooks/push'
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