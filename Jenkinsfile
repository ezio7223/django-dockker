pipeline {
    agent any
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout'){
           steps {
                url: 'https://github.com/ezio7223/django-dockker',
                branch: 'main'
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
            environment {
            GIT_REPO_NAME = ""
            GIT_USER_NAME = "ezio7223"
            }
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'f87a34a8-0e09-45e7-b9cf-6dc68feac670', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                    sh '''
                    cat deployment.yaml
                    sed -i '' "s/32/${BUILD_NUMBER}/g" deployment.yaml
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