#!/usr/bin/env groovy

def getHost() {
    def remote = [:]
    remote.name = 'manager node'
    remote.user = 'root'
    remote.port = 32200
    remote.identityFile = '/root/.ssh/id_rsa'
    remote.allowAnyHosts = true
    return remote
}

pipeline {
    agent any

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
                sh "sh build.sh ${BRANCH_NAME} ${SERVICE_NAME} "
            }
        }

        stage('init-server'){
            steps {
                script {
                   server = getHost()
                   server.host = '${REMOTE_HOST}'
                }
            }
        }

        stage('执行发版') {
            steps {
                sshCommand remote: server, command: "sudo docker stack deploy -c docker-compose.yml myapp"
            }
        }
    }
}