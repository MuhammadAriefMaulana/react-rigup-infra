pipeline {
    agent any
    environment {
        SERVICE_ACCOUNT = 'devops-telkomsel-7-new@group7-322208.iam.gserviceaccount.com'
        KEY_TEXT = credentials('devops-telkomsel-7-new-SA-text') //add di credential
        KEY_FILE = 'devops-telkomsel-7-new-SA' //add di credential
        KUBE_CLUSTER = 'mariefm-2'
        // KUBE_ZONE = 'us-west2-a'
        // PROJECT_ID = 'group7-322208'
        // NAMESPACE = 'mariefm'
    }

    stages {
        stage('Check Jenkins Workspace') {
            when {
                anyOf {
                    branch "main"
                    branch "mariefm"
                    changeRequest()
                }
            }
            steps {
                sh "chmod +x -R ${env.WORKSPACE}"
                // sh 'sudo groupadd docker'
                // sh 'sudo usermod -aG docker $USER'
                sh './jenkins/scripts/test.sh'
            }
        }
        
        stage('Terraform Init & Plan') {
            when {
                anyOf {
                    changeset "**/*.tf"
                }
            }
            steps {
                script {
                    dir('./terraform') {
                        sh '''
                        mkdir -p creds
                        echo $KEY_TEXT | base64 -d > ./creds/serviceaccount.json
                        terraform init -force-copy || exit 1
                        terraform plan -out my.tfplan || exit 1
                        '''
                    }                        
                }
                input message: "Continue to Terraform Apply?"               
            }
        }

        // stage('Terraform Destroy') {
        //     steps {
        //         script {
        //             dir('./terraform') {
        //                 sh 'terraform destroy'
        //             }       
        //         }
        //     }
        // }

        stage('Terraform Apply') {
            when { 
                allOf {
                    branch "main"
                    changeset "**/*.tf"
                }
            }
            steps {
                script {
                    dir('./terraform') {
                        sh '''                            
                        terraform apply -input=false -auto-approve
                        terraform output kube_cluster | sed 's/"//g' > ./creds/kube_cluster.txt
                        terraform output kube_zone | sed 's/"//g' > ./creds/kube_zone.txt
                        terraform output project_id | sed 's/"//g' > ./creds/project_id.txt
                        '''
                        env.KUBE_CLUSTER = sh (
                            script: 'cat ./creds/kube_cluster.txt',
                            returnStdout: true
                        )
                        env.KUBE_ZONE = sh (
                            script: 'cat ./creds/kube_zone.txt',
                            returnStdout: true
                        )
                        env.PROJECT_ID = sh (
                            script: 'cat ./creds/project_id.txt',
                            returnStdout: true
                        )
                        echo "KUBE_CLUSTER= ${KUBE_CLUSTER}"
                        echo "KUBE_ZONE= ${KUBE_ZONE}"
                        echo "PROJECT_ID= ${PROJECT_ID}"  
                    }                        
                }
            }
        }
    }
}