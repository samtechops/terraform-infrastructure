// node('jenkins-slave') {

    
//     stage('create tf remote state') {
//         steps {
//             withCredentials([usernamePassword(credentialsId: 'jenkins-cloud-deployment-pipeline', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
//                 sh(script: """
//                     echo "Creating S3 terraform remte state Bucket"
//                     git clone https://github.com/samtechops/terraform-infrastructure.git
//                     cd ./terraform-infrastructure
//                     chmod +x ./scripts/create_state_bucket.sh
//                     ./scripts/create_state_bucket.sh
//                 """)
                
//             }
//         }
//     }

// }

// node('jenkins-slave') {
//     withCredentials([[$class:'AmazonWebServicesCredentialsBinding', credentialsId: "credentials-id-here", accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
//         script {
//             def creds = readJSON text: secret
//             env.AWS_ACCESS_KEY_ID = creds['accessKeyId']
//             env.AWS_SECRET_ACCESS_KEY = creds['secretAccessKey']
//             env.AWS_REGION = 'us-east-1' // or whatever
//         }
//         sh "aws sts get-caller-identity" // or whatever
//         stage('create tf remote state') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: 'jenkins-cloud-deployment-pipeline', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
//                     sh(script: """
//                         echo "Creating S3 terraform remte state Bucket"
//                         git clone https://github.com/samtechops/terraform-infrastructure.git
//                         cd ./terraform-infrastructure
//                         chmod +x ./scripts/create_state_bucket.sh
//                         ./scripts/create_state_bucket.sh
//                     """)
                    
//                 }
//             }
//         }
//     }
// }
pipeline {
    agent { 
        node { label 'jenkins-slave' } }

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
    }

    stages {
        // your pipeline code here
        stage('Description') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'jenkins-cloud-deployment-pipeline', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    script {
                        def version_display;
                        if (params.REFRESH_JENKINSFILE == true) {
                            currentBuild.description = "Refreshing Jenkinsfile"
                        }
                        PARENT_JOB = "Triggered by ${currentBuild.projectName} #${currentBuild.number}:"
                    }
                    echo "Creating S3 terraform remte state Bucket"
                    git url: 'https://github.com/samtechops/terraform-infrastructure.git'
                    sh "cd ./terraform-infrastructure"
                    sh "chmod +x ./scripts/create_state_bucket.sh"
                    sh "./scripts/create_state_bucket.sh"
                }
            }
        }
    }

}