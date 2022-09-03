pipeline {
    agent { 
        node { label 'jenkins-slave' } }

    // environment {
    //     AWS_DEFAULT_REGION = 'eu-west-1'
    // }

    stages {
        // your pipeline code here
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'origin/main']],
                    extensions: scm.extensions,
                    userRemoteConfigs: [[url: 'https://github.com/samtechops/terraform-infrastructure.git']]
                    ])

                stash includes: "terraform-infrastructure/*", name: "terraform-infrastructure"
                }
        }
        stage('Create TF Remote State') {
            steps {
                withAWS(credentials: 'sam-jenkins-aws-creds', region: 'eu-west-1') {
                    echo "Creating S3 terraform remte state Bucket"
                    unstash "terraform-infrastructure"
                    sh "cd ./terraform-infrastructure"
                    sh "chmod +x ./scripts/create_state_bucket.sh"
                    sh "./scripts/create_state_bucket.sh"
                }
            }
        }
        stage('Create TF State Lock') {
            steps {
                withAWS(credentials: 'sam-jenkins-aws-creds', region: 'eu-west-1') {
                    echo "Creating S3 terraform remte state Bucket"
                    unstash "terraform-infrastructure"
                    sh "cd ./terraform-infrastructure"
                    sh "chmod +x ./scripts/create_dynamodb_terraform_lock.sh"
                    sh "./scripts/create_dynamodb_terraform_lock.sh"
                }
            }
        }
    }

}