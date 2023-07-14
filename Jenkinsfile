pipeline {
  agent any


  environment {
        NEXUS_VERSION = "${env.NEXUS_VERSION}"
        NEXUS_PROTOCOL = "${env.NEXUS_PROTOCOL}"
        NEXUS_URL = "${env.NEXUS_URL}"
        NEXUS_REPOSITORY_SNAPSHOT = "${env.NEXUS_REPOSITORY_SNAPSHOT}"
        NEXUS_REPOSITORY_RELEASE = "${env.NEXUS_REPOSITORY_RELEASE}"
        NEXUS_CREDENTIAL_ID = "${env.NEXUS_CREDENTIAL_ID}"
  }
  
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

  stage('SonarQube analysis') {            
        environment {
            SCANNER_HOME = tool 'sonarqube'
        }
        steps {
            echo "------------------ SonarQube analysis ----------------------"
            script {
                artifactId = readMavenPom().getArtifactId()
                version = readMavenPom().getVersion().replaceAll("-.*\$", "")
                groupId = readMavenPom().getGroupId()
            }
            echo "*** Projectkey: ${groupId}:${artifactId}, Projectname: ${artifactId}, Projectversion: ${version} ***"
            withSonarQubeEnv(credentialsId: 'sonarqube', installationName: 'sonarqube') {
                sh """$SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=${groupId}:${artifactId} \
                    -Dsonar.projectName=${artifactId} \
                    -Dsonar.projectVersion=${version} \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/classes/ \
                    -Dsonar.exclusions=src/main/java/com/kalavit/javulna/****/*.java \
                    -Dsonar.java.libraries=/home/jenkins/.m2/**/*.jar"""
            }
        }
    }
    stage('SQuality Gate') {
        when {
            branch 'develop'
            environment name: 'IS_RELEASE', value: 'false'
        }
        steps {
            timeout(time: 10, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
    // 5.
    stage('Publish') {
          when {
              branch 'develop'
          }
          steps {
              script {
                  if (params.IS_RELEASE) {
                      sh "git checkout main"
                  }
                  artifactId = readMavenPom().getArtifactId()
                  version = readMavenPom().getVersion()
                  groupId = readMavenPom().getGroupId()
              }
              echo "*** File: ${artifactId}, ${version}, ${groupId}"
              nexusArtifactUploader (
                  nexusVersion: NEXUS_VERSION, 
                  protocol: NEXUS_PROTOCOL, 
                  nexusUrl: NEXUS_URL, 
                  groupId: "${groupId}", 
                  version: "${version}", 
                  repository: NEXUS_REPOSITORY, 
                  credentialsId: NEXUS_CREDENTIAL_ID, 
                  artifacts: [
                      [artifactId: "${artifactId}",  classifier: '', file: "target/${artifactId}-${version}.jar", type: 'jar'],
                      [artifactId: "${artifactId}", classifier: '', file: 'pom.xml', type: 'pom']
                  ]
              )
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
