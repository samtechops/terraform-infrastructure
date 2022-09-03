node('jenkins-slave') {
    
     stage('create tf remote state') {
        sh(script: """
            echo "Creating S3 terraform remte state Bucket"
            git clone https://github.com/samtechops/terraform-infrastructure.git
            cd ./terraform-infrastructure
            chmod +x ./scripts/create_state_bucket.sh
            ./scripts/create_state_bucket.sh
        """)
    }
}