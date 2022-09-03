node('jenkins-slave') {
    
     stage('test pipeline') {
        sh(script: """
            echo "hello"
            terraform --version
            aws --version
           
        """)
    }
}