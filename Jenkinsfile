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
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t ezio7223/pythontest-django-app:${BUILD_NUMBER} .
                    '''
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
                    cat deployment.yaml
                    sed -i 's|replaceImageTag|'"${BUILD_NUMBER}"'|g' deployment.yaml
                    cat deployment.yaml
                    git add deployment.yaml
                    git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                    git remote -v
                    git push https://github.com/ezio7223/django-dockker HEAD:main
                        '''
                    }
                }
            }
        }
    }
}