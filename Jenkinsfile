pipeline {
    agent { node { label 'jenkins-slave' } }

    parameters {
        booleanParam(defaultValue: false, name: 'CREATE_AWS_PREREQS', description: 'If true, the pipeline will create TF S3 remote state & DynamoDB state lock')
        choice(
            name: 'TF_ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Terraform Action'
        )
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
                checkout scm
            }
        }

        stage('Create TF Remote State') {
            when {
                expression { 
                    return params.CREATE_AWS_PREREQS == true
                }
            }
            steps {
                echo "Creating S3 Terraform Remote State Bucket"

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

                sh "chmod +x ./scripts/create_dynamodb_terraform_lock.sh"
                sh "./scripts/create_dynamodb_terraform_lock.sh"
            }
        }
        stage('TF Plan') {
            when {
                expression { 
                   return params.TF_ACTION == 'PLAN'
                }
            }
            steps {
                echo "Terraform Plan"
                
                dir('base') {
                    sh "terraform init -reconfigure -backend-config=\"bucket=$TF_S3_STATE_BUCKET\" -backend-config=\"region=$AWS_DEFAULT_REGION\" -no-color"
                    sh "terraform plan -no-color"
                }
            }
        }
        stage('TF Apply') {
            when {
                expression { 
                   return params.TF_ACTION == 'APPLY'
                }
            }
            steps {
                echo "Terraform Apply"
                
                dir('base') {
                    sh "terraform init -reconfigure -backend-config=\"bucket=$TF_S3_STATE_BUCKET\" -backend-config=\"region=$AWS_DEFAULT_REGION\" -no-color"
                    sh "terraform apply -auto-approve -no-color"
                }
            }
        }
        
    }

}