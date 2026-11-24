
pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

    environment {
        DOCKER_IMAGE = 'nanducjc123/educationrepo'
        SONAR_HOST = 'http://35.154.110.139:9000'
        CONTAINER_NAME = 'educationapp'
        APP_PORT = '8080'
    }

    stages {

        // 1. Download source code from GitHub
        stage('Git Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/cjcnkolhe/educationwebapp_devops_project.git'
            }
        }

        // 2. Build Java application
        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        // 3. SonarQube code analysis
        stage('SonarQube Analysis') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'sonar-token',
                        variable: 'SONAR_TOKEN'
                    )
                ]) {
                    sh '''
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:5.8.0.7211:sonar \
                        -Dsonar.projectKey=my-project \
                        -Dsonar.projectName=my-project \
                        -Dsonar.host.url=$SONAR_HOST \
                        -Dsonar.token=$SONAR_TOKEN
                    '''
                }
            }
        }

        // 4. Create Docker image
        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE:latest .
                '''
            }
        }

        // 5. Login to Docker Hub and push image
        stage('Docker Login & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        set +x
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USER" --password-stdin

                        docker push $DOCKER_IMAGE:latest
                        docker logout
                    '''
                }
            }
        }

        // 6. Download image from Docker Hub
        stage('Docker Pull') {
            steps {
                sh '''
                    docker pull $DOCKER_IMAGE:latest
                '''
            }
        }

        // 7. Deploy application using Docker
        stage('Docker Run / Deploy') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true

                    docker run -d \
                    --name $CONTAINER_NAME \
                    --restart unless-stopped \
                    -p 8081:$APP_PORT \
                    $DOCKER_IMAGE:latest

                    docker ps
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
            echo 'Docker application deployed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }

        always {
            echo 'Jenkins pipeline execution finished.'
        }
    }
}
