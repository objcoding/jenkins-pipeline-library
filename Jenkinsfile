#!/usr/bin/env groovy

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

        stage('执行发版') {
            steps {
                sshCommand remote: [name: "manager node", host: "193.112.61.178", port: "32200" user: "root", allowAnyHosts: true], command: "sudo docker stack deploy -c docker-compose.yml myapp"
            }
        }
    }
}