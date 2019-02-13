#!/usr/bin/env groovy

def getHost() {
    def remote = [:]
    remote.name = 'manager node'
    remote.host = '193.112.61.178'
    remote.user = 'root'
    remote.port = 32200
    remote.identity = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCayXDbBXLywJEIJ/aQPf0gizovq8BypiQEV+B+hgWqkp0JVOQCpdjc3upDPLKbG2lMNvVQWPeiwhHEcuK8uXNJ09+ey3CXR+rZmqfiNUh2M1HGwdRxhSGA96gKll3TT7IX/DUbYw3TzGustJ4fsyllczhL7MQDZTM1o6Dxzs8B0rSZOTUZX7aMA/8dTV3cFiEP8qNW69PWOaMHRhjBMQAC3PwKVmhG424ijSsUxGDmEY8dV3GtNbbJCFiYZxjxIFkLujsg0qBC4QTBIHZQQFpzJI9BYkCIhdnp7w5NkFarMJn/VOGTYaGqdzBShsap0iD8f6pS4Wq1espbpxcHqmhj root@c5a425bf535a'
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