#!/bin/bash
echo hello $1. Today is $2.




def nodeCreation =
node('master'){
        stage ('git checkout') {
        git branch: 'main', credentialId: 'github-connect', url: 'https://github.com/kushmodi/POC.git'
         }
            withAWS(credentials: 'POC', region: 'us-west-2') {
            withCredentials([usernamePassword(credentialsId: 'jenkins-credentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
            stage ('create build agent') {
             def res = sh '''cd key_pair_sg_build
                              terraform init
                              terraform apply -auto-approve
                               cd ..
                               terraform init
                               terraform apply -auto-approve -state=terraform-state-${BUILD_NUMBER} -var name=jenkins_slave-${BUILD_NUMBER} -var "username=${USERNAME}" -var "password=${PASSWORD}"
                               sleep 60'''
         }
       }
     }
   }
createdNode = print ("Execution on $nodeCreation is successful")
print ("Result of $createdNode")

if(createdNode == null) {
       node ('ec2-instance'){
       stage ('run build on newly created agent'){
             sh '''hostname
                hostname -I
                sleep 480'''
             }
       }
   }
else {
    echo "Error in execution on slave"
}

node ('master'){
        stage ('destroy newly built agent') {
             withAWS(credentials: 'POC', region: 'us-west-2') {
             withCredentials([usernamePassword(credentialsId: 'jenkins-credentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                  def result = sh 'terraform destroy -auto-approve -state=terraform-state-${BUILD_NUMBER} -var name=jenkins_slave-${BUILD_NUMBER} -var "username=${USERNAME}" -var "password=${PASSWORD}"'
                      if(result == null) {
                         sh 'java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080 -auth ${USERNAME}:${PASSWORD} delete-node jenkins_slave-${BUILD_NUMBER}'
                      }
                      else {
                         echo "Errors in the destroy command"
                        }
                  }
              }
        }
}
