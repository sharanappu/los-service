pipeline {
  agent any
  environment {
    AWS_REGION = 'ap-south-1'
    ECR_REGISTRY = '123456789012.dkr.ecr.ap-south-1.amazonaws.com' // REPLACE with your account
    IMAGE_NAME = 'los-service'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build') { steps { sh 'mvn -B -DskipTests package' } }
    stage('Unit Tests') { steps { sh 'mvn test || true'; junit 'target/surefire-reports/*.xml' } }
    stage('Build Docker') { steps { sh 'docker build -t ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .' } }
    stage('Push to ECR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-jenkins-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh '''
            aws configure set region ${AWS_REGION}
            aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
            aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
            aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
            docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }
  }
}
