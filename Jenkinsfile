pipeline {
    agent {
         docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    } // we chose to use docker agent considering its avantages
    }
    
    stages {
        stage (checkout){
            sh "echo passed"
            // checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/MalickReborn/springmvc-for-my-CICD.git']])
        }
        stage('Build and test') {
            steps {
                sh  'cd /springmvc-for-my-CICD && mvn clean package'
            }
        }
        
        stage(Static Code Analysis){
            environment(
                 SONAR_URL = "http://localhost:9000/") // we have opted here for a docker container as a sonarqube server
                 steps{
                     withCredentials([string(credentialsId: 'sonar', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd /springmvc-for-my-CICD && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
                     
                 }
            
        }
        
        stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "abhishekf5/ultimate-cicd:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
          environment {
        DOCKER_IMAGE = "malickguess/ultimate-cicd:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "springmvc-for-my-CICD/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('dockerhub')
      }
        script {
            sh 'cd /springmvc-for-my-CICD && docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "dockerhub") {
                dockerImage.push()
            }
        }
      }
    }
    }
}
