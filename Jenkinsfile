pipeline {
    agent any
    environment {
        IMAGE_NAME = "ezio7223/pythontest-django-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
        REPORTS_DIR = "security-reports"
    }

    stages {
        stage('Checkout'){
           steps {
                git branch: 'main', url: 'https://github.com/ezio7223/django-dockker.git'
           }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                python3 -m venv venv  # Create a virtual environment
                source venv/bin/activate  # Activate the virtual environment
                pip install --upgrade pip  # Upgrade pip inside the virtual environment
                pip install -r requirements.txt || echo "⚠️ Dependency install issues"
                '''
            }
        }

        stage('Run Bandit (SAST - Python Security Scan)') {
            steps {
                sh '''
                source venv/bin/activate  # Activate venv
                pip install bandit
                mkdir -p ${REPORTS_DIR}
                bandit -r . -f json -o ${REPORTS_DIR}/bandit-report.json
                '''
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

        stage('Run Trivy (Container & Dependency Scan)') {
            steps {
                sh 'docker pull aquasec/trivy'
                sh "mkdir -p ${REPORTS_DIR}"
                sh "trivy image --format json --output ${REPORTS_DIR}/trivy-report.json ${DOCKER_IMAGE}"
                sh 'trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE} || echo "⚠️ Security vulnerabilities found, check reports!"'
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
                    git commit -m "Updated deploy YAML | Jenkins Pipeline" || echo "⚠️ No changes to commit."
                    git push https://ezio7223:${GITHUB_TOKEN}@github.com/ezio7223/django-dockker HEAD:main
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            echo " Archiving Security Reports..."
            archiveArtifacts artifacts: "${REPORTS_DIR}/*.json", fingerprint: true
            echo "Cleaning up Docker images..."
            sh "docker rmi ${DOCKER_IMAGE} || true"
        }
        failure {
            echo "🚨 Pipeline Failed! Check security reports in Jenkins artifacts:"
            echo "🔍 Bandit Report: ${WORKSPACE}/${REPORTS_DIR}/bandit-report.json"
            echo "🔍 Trivy Report: ${WORKSPACE}/${REPORTS_DIR}/trivy-report.json"
        }
        success {
            echo "✅ Deployment Successful!"
        }
    }
}