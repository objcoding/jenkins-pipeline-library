#!/usr/bin/env groovy

def getServer() {
    def remote = [:]
    remote.name = 'manager node'
    remote.user = 'dev'
    remote.host = "${REMOTE_HOST}"
    remote.port = 22
    remote.identityFile = '/root/.ssh/id_rsa'
    remote.allowAnyHosts = true
    return remote
}

def call(Map map) {

    pipeline {
        agent any

        environment {
            REMOTE_HOST = "${map.REMOTE_HOST}"
            REPO_URL = "${map.REPO_URL}"
            BRANCH_NAME = "${map.BRANCH_NAME}"
            STACK_NAME = "${map.STACK_NAME}"
            COMPOSE_FILE_NAME = "docker-compose-" + "${map.STACK_NAME}" + "-" + "${map.BRANCH_NAME}" + ".yml"
        }

        stages {
            stage('获取代码') {
                steps {
                    git([url: "${REPO_URL}", branch: "${BRANCH_NAME}"])
                }
            }

            stage('编译代码') {
                steps {
                    withMaven(maven: 'maven 3.6') {
                        sh "mvn -U -am clean package -DskipTests"
                    }
                }
            }

            stage('构建镜像') {
                steps {
                    sh "wget -O build.sh https://git.x-vipay.com/docker/jenkins-pipeline-library/raw/master/resources/shell/build.sh"
                    sh "sh build.sh ${BRANCH_NAME} "
                }
            }

            stage('init-server') {
                steps {
                    script {
                        server = getServer()
                    }
                }
            }

            stage('执行发版') {
                steps {
                    writeFile file: 'deploy.sh', text: "wget -O ${COMPOSE_FILE_NAME} " +
                            " https://git.x-vipay.com/docker/jenkins-pipeline-library/raw/master/resources/docker-compose/${COMPOSE_FILE_NAME} \n" +
                            "sudo docker stack deploy -c ${COMPOSE_FILE_NAME} ${STACK_NAME}"
                    sshScript remote: server, script: "deploy.sh"
                }
            }
        }
    }
}
