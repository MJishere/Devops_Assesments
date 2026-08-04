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
                sh "echo Job complete"
            }
        }
    }
}