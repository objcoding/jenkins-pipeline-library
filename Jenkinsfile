#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        GIT_REPO = "${GIT_REPO_URL}"
        BUILD_IMAGE_SCRIPT_PATH = "https://github.com/objcoding/docker-jenkins-script/blob/master/build.sh"
    }

    stages {
        stage('获取代码') {
            steps {
                git([url: "${GIT_REPO}", branch: "master"])
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
                sh "sh ${BUILD_IMAGE_SCRIPT_PATH} master"
            }
        }


    }
}