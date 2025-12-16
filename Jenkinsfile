pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven'
    }

    environment {
        IMAGE_NAME = "los-service:local"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sharanappu/los-service.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                sh "docker rm -f los || true"
                sh "docker run -d -p 8080:8080 --name los ${IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo 'LOS service deployed successfully!'
        }
        failure {
            echo 'Build failed. Check logs!'
        }
    }
}

