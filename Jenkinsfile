pipeline {
    agent any
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    echo 'Buid Docker Image'
                    docker build -t ezio7223/pythontest-django-app:${BUILD_NUMBER} .
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
                    docker push ezio7223/pythontest-django-app:${BUILD_NUMBER}
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
                    git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                    git remote -v
                    git push https://ezio7223:${GITHUB_TOKEN}@github.com/ezio7223/django-dockker HEAD:main
                        '''
                    }
                }
            }
        }
    }
}