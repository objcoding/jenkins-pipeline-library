#!/usr/bin/env groovy

def getHost() {
    def remote = [:]
    remote.name = 'manager node'
    remote.host = '193.112.61.178'
    remote.user = 'root'
    remote.port = 32200
    remote.identity = 'MIIEowIBAAKCAQEAvHU9R7IoFyb0WQH3JKlPI7ANIi/6rz4XylMblooAapiSl1pa
                       hp3IOdlR1LgIEemzgIEouuVIMEHdIss3vNaBPCnbQM2CqrY0oIUQL7sb5zHAZj4X
                       avmLslSEBom5WbZz6QP5D1Lm6CR33Tv8DpNmxxIUvRWfF3tRSdMNozOa+T+fyK7d
                       7pS5j6oOeCoH3wC+bdkqZ+2hcpS3jD+0xmprmK2zx0u7xAJ3Ce67PKDiKvZbfow6
                       TB0CqYguaOr8v2in88YnZuaW6opUkffmKJhtRRK3tOKIneXBr2Nlydtiwfizm9L6
                       iovKabSXFDD4zQP8Hfv7wzoV/HMdpiAYRzOnmwIDAQABAoIBAFBxIrUlwKMRR59u
                       jVWix1sOXKzJGhIPSQxdqRr60O6vLXNZZ+aqFrtKnflUjG1I+gvSFdag481lb8TY
                       RXRfg05w91uT3UCNAa263ovhLCnlPKDnxAsvdYerN6eqxekbTiKaRYda9aEFX/yZ
                       DCAUnvw+JYgIYJ4fTzVZ1ypgbrgQySliBZBGtOcVIaG7ODOIyZfcTBdUdb+Ea7Jb
                       NiT4OoxzcSAMJrElchEKufoBYlCMKnjBCgHlX2ZmruG3fM9qGAeK4PuL65nd0fwO
                       q8J8MgDpTIYpRSa2lRYkNaUdtKbROy1iedv3gTuSduX2rZQLXD8rs0YeMaMPmiAw
                       OAQi73ECgYEA+y58/g5eTv+61naU7/6bcBsD4dBTVyhAGLlvgtMZSB3Ra2ZXDqGN
                       87eICnVVgQxSH4MC3SfvsgMuYZnXA27SGhtniT1Z/DEl4HNt9qBo3ut7tU2kTGR7
                       gPmQwJLHVQtuZ6ececUn1krjyU1RUro3fZNfqgNgrAc3ZKrsQMBO310CgYEAwBK5
                       w3LxYs3HbBHKcj+Y7XWuuF7JOg5Z3LdVJDQWOgEcZqf1ZtJvNl9xlvJZKIvw4HE6
                       O/ffL+031jZ8JekF6bEHXS8M0pq0PIj7OyqfavFApOGinRUWLAWE7xv/C0+D7Woy
                       AekyROFgT6FyzoQMIVIlsgX4yXfijylXKgzzy1cCgYBA4SEn/k4d2bBI9RhDZWCA
                       9HlsOoNMX/kuabeD80L0fb86HpUeEly4Nw/Mo8ISMzyDJzP2K/qd4HR6gWIoYNek
                       Jq/3owE7QvaloyskKQrtiaXKjuOBV/MOvWfGViNmtC0wWPrx+RrxHyb3OCFpXPA4
                       X3i2UWkHBlYoin27u/CjgQKBgBI3tHbdSBfe/LM7XMBJV+/t4YyLMPrYsZ1FpkWw
                       ywrlYBQ8igIeo328v8FZayt1WntvQd6+O+UH0uv2bwAJgg4QRGqKM+Ul10KGm42Z
                       FVXHXCJHZG0RuvCh9WHYffBMsm6qS+PygloWJlRnM8RysdPXPswL1PUG8e4yNZo/
                       cEAxAoGBAI2l92BDIB4Z6HE+gJUFTTt0dgUCt5R+RkUiGhMKeMmMbHWw9o2rmcvw
                       asp/M9lkn1UEsgu1RURRJvZbvjg2Ci2X1vQVrk6xk1YGtAh1an2RCwSyH7hWSkO5
                       NcV5Oyiy+FsawtxPR63AiUZT5z9IBrSRW3SXm7G8/2rdvQjWXaAF'
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