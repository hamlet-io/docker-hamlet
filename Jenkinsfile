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
        DOCKER_TAG = "${env.TAG_NAME ?: 'master'}"
    }

    stages {
        stage('setup') { 
           steps {
               sh 'docker login --username ${DOCKERHUB_CREDENTIALS_USR} --password ${DOCKERHUB_CREDENTIALS_PSW}'
               script { 
                    env.SOURCE_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%H'").trim()
                    env.SOURCE_BRANCH = sh(returnStdout: true, script: "git rev-parse --abbrev-ref HEAD").trim()
               }
           } 
        }
        stage('build') { 
            parallel { 
                stage('stretch') { 
                    steps {
                        echo 'Source Commit: ${env.SOURCE_COMMIT} - Source Branch ${env.SOURCE_BRANCH}'
                        sh '''
                            dockerstagedir="$(mktemp -d "${DOCKER_STAGE_DIR}/cota_docker_XXXXXX")"

                            cp -r ./ "${dockerstagedir}/"
                            cd "${dockerstagedir}/images/stretch"

                            ./hooks/build
                        '''
                    }
                }
                stage('alpine') { 
                    steps { 
                        sh '''
                            dockerstagedir="$(mktemp -d "${DOCKER_STAGE_DIR}/cota_docker_XXXXXX")"

                            cp -r ./ "${dockerstagedir}/"
                            cd "${dockerstagedir}/images/alpine"
                            
                            ./hooks/build
                        '''
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