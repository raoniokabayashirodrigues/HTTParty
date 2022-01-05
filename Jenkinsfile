pipeline {
    agent {
        docker {
            image 'ruby'
            args '--network rocklov-network'

        }
    }

    stages {
        stage ('Prep'){
            steps {
                sh 'bundle install'
            }
        }
        stage('Testing') {
            steps {
                sh 'rspec'
                junit 'logs/report.xml'
            }
        }
    }
    post {
        always {
            junit 'logs/report.xml'
        }
    }
}
