pipeline {
  agent any
  
  stages {
    // 1.
    stage('Checkout') {
      steps {
        git 'https://github.com/hmosqueraturner/ideal-cicd-one.git'
      }
    }
    // 2.
    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
    // 3.
    stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    // 4.
    stage('Linting SonarQube') {
     steps {
         script {
         def scannerHome = tool 'sonarqube';
             withSonarQubeEnv("sonarqube-container") {
             sh "${tool("sonarqube")}/bin/sonar-scanner \
             -Dsonar.projectKey=test-node-js \
             -Dsonar.sources=. \
             -Dsonar.css.node=. \
             -Dsonar.host.url=http://your-ip-here:9000 \
             -Dsonar.login=your-generated-token-from-sonarqube-container"
             }
         }
      }
   }
    // 5.
    stage('Publish') {
      steps {
        
      }
    }
    // 6.
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t tu-repositorio-docker/nombre-imagen:$BUILD_NUMBER .'
        withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
        }
        sh 'docker push tu-repositorio-docker/nombre-imagen:$BUILD_NUMBER'
      }
    }
    // 7.
    stage('Provision Infrastructure') {
      steps {
        sh 'terraform init'
        sh 'terraform plan -out=tfplan'
        sh 'terraform apply -auto-approve tfplan'
      }
    }
    // 8.
    stage('Deploy Ansible') {
      steps {
        ansiblePlaybook(
          playbook: 'ansible/acid-main.yml',
          inventory: 'ansible/hosts',
          extras: "-e 'image_version=$BUILD_NUMBER'"
        )
      }
    }
    stage('Notify') {
      steps {
        
      }
    }
  }
}
