#!groovy
import groovy.json.JsonSlurper
import groovy.json.JsonOutput

def serviceName = "traefik"
def serviceImage = "<registry host>/devops/traefik"

node {
    currentBuild.result = "SUCCESS"

    try {
        stage('Checkout') {
            step([$class: 'WsCleanup'])
            checkout scm
        }

        if (env.BRANCH_NAME == 'master') {

            stage('Build') {
                sh "./jenkins/build.sh ${serviceImage}"
            }

            stage('Push') {
                sh "./jenkins/push.sh ${serviceImage}"
            }

            stage('Deploy') {
                sh "./jenkins/deploy.sh testing ${serviceName} ${serviceImage}"
                sh "./jenkins/deploy.sh staging ${serviceName} ${serviceImage}"
            }

        }
    } catch (err) {
        currentBuild.result = "FAILURE"

        throw err
    }
}
