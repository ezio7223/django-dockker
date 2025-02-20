pipeline {
    agent any
    environment {
        IMAGE_NAME = "ezio7223/pythontest-django-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout'){
           steps {
                git branch: 'main', url: 'https://github.com/ezio7223/django-dockker.git'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    withCredentials([string(credentialsId: 'dockerhub', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                    echo "Logging into Docker Hub..."
                    echo "$DOCKER_TOKEN" | docker login -u "ezio7223" --password-stdin
                    echo 'Build Docker Image'
                    docker build -t ${DOCKER_IMAGE} .
                    '''
                    }
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                    sh '''
                    echo 'Push to Repo'
                    docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Update deployment file'){
            steps {
                script{
                    withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                    echo "deployment.yml"
                    sed -i 's|replaceImageTag|'"${BUILD_NUMBER}"'|g' deployment.yml
                    cat deployment.yml
                    git config --global user.email "kpsafwan10@gmail.com"
                    git config --global user.name "Jenkins"
                    git add deployment.yml
                    git commit -m "Updated deploy YAML | Jenkins Pipeline" || echo "️ No changes to commit."
                    git push https://ezio7223:${GITHUB_TOKEN}@github.com/ezio7223/django-dockker HEAD:main
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Cleaning up Docker images..."
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
        failure {
            echo " Pipeline Failed! Check security reports in Jenkins artifacts:"
        }
        success {
            echo " Deployment Successful!"
        }
    }
}