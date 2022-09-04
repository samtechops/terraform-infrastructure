pipeline {
    agent { node { label 'jenkins-slave' } }

    parameters {
        booleanParam(defaultValue: false, name: 'CREATE_AWS_PREREQS', description: 'If true, the pipeline will create TF S3 remote state & DynamoDB state lock')
    }

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

    stages {
        // your pipeline code here
        stage('Checkout') {
            steps {
                // sh "git clone https://github.com/samtechops/terraform-infrastructure.git"
                // stash includes: "terraform-infrastructure/*", name: "terraform-infrastructure"
                checkout scm
                }
        }

        stage('Create TF Remote State') {
            when {
                expression { 
                    return params.ENVIRONMENT == true
                }
            }
            steps {
                echo "Creating S3 Terraform Remote State Bucket"
                // unstash "terraform-infrastructure"
                sh "cd ./terraform-infrastructure"
                sh "chmod +x ./scripts/create_state_bucket.sh"
                sh "./scripts/create_state_bucket.sh"
            }
        }
        stage('Create TF State Lock') {
            when {
                expression { 
                   return params.CREATE_AWS_PREREQS == true
                }
            }
            steps {
                echo "Creating DynamoDB Terraform Lock"
                // unstash "terraform-infrastructure"
                sh "cd ./terraform-infrastructure"
                sh "chmod +x ./scripts/create_dynamodb_terraform_lock.sh"
                sh "./scripts/create_dynamodb_terraform_lock.sh"
            }
        }

        
    }

}