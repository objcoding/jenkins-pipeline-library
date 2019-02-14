#!/usr/bin/env groovy

def getServer() {
    def remote = [:]
    remote.name = 'manager node'
    remote.user = 'root'
    remote.host = "${REMOTE_HOST}"
    remote.port = 32200
    remote.identityFile = '/root/.ssh/id_rsa'
    remote.allowAnyHosts = true
    return remote
}

pipeline {
    agent any

    environment {
        BRANCH_NAME = "master"
        REMOTE_HOST = "193.112.61.178"
        COMPOSE_FILE_NAME = "docker-compose-" + "${STACK_NAME}" + ".yml"
    }

    stages {
        stage('获取代码') {
            steps {
                git([url: "${GIT_REPO_URL}", branch: "${BRANCH_NAME}"])
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
                sh "sh build.sh ${BRANCH_NAME} "
            }
        }

        stage('init-server'){
            steps {
                script {
                   server = getServer()
                }
            }
        }

        stage('执行发版') {
            steps {
                sshCommand remote: server, command: "sudo docker stack deploy -c ${COMPOSE_FILE_NAME} ${STACK_NAME}"
            }
        }
    }
}