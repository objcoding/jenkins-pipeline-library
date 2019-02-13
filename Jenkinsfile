#!/usr/bin/env groovy

def getHost() {
    def remote = [:]
    remote.name = 'manager node'
    remote.host = '193.112.61.178'
    remote.user = 'root'
    remote.port = 32200
    remote.identity = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8dT1HsigXJvRZAfckqU8jsA0iL/qvPhfKUxuWigBqmJKXWlqGncg52VHUuAgR6bOAgSi65UgwQd0iyze81oE8KdtAzYKqtjSghRAvuxvnMcBmPhdq+YuyVIQGiblZtnPpA/kPUuboJHfdO/wOk2bHEhS9FZ8Xe1FJ0w2jM5r5P5/Irt3ulLmPqg54KgffAL5t2Spn7aFylLeMP7TGamuYrbPHS7vEAncJ7rs8oOIq9lt+jDpMHQKpiC5o6vy/aKfzxidm5pbqilSR9+YomG1FEre04oid5cGvY2XJ22LB+LOb0vqKi8pptJcUMPjNA/wd+/vDOhX8cx2mIBhHM6eb root@chenghui.zhang'
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
                }
            }
        }

        stage('执行发版') {
            steps {
                sshCommand remote: server, command: """ if test ! -d aaa/ccc ;then mkdir -p aaa/ccc;fi;cd aaa/ccc;rm -rf ./*;echo 'aa' > aa.log """
            }
        }
    }
}