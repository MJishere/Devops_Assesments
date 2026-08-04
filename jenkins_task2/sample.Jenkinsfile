pipeline {
    agent any

    stages {
        stage("Checkout SCM") {
            steps {
                checkout scm
            }
        }

        stage("Execute script") {
            steps {
                sh "chmod +x ./jenkins_task2/hello.sh"
                sh "./jenkins_task2/hello.sh"
                sh "echo Job complete!"
            }
        }
    }
    post {
        always {
            mail to: "manojmjhere2@gmail.com",
                 subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: """
Build Status: ${currentBuild.currentResult}

Job Name: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}

Build URL:
${env.BUILD_URL}
"""
        }
    }
}