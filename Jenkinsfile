node {
    checkout scm
    stage("Build"){
        docker.image('composer:2.6').inside('-u root') {
            sh 'rm -f composer.lock'
            sh 'composer install'
        }
    }
    stage("Testing"){
        docker.image('ubuntu').inside('-u root') {
            sh 'echo "Ini adalah test"'
        }
    }
    stage("Deploy"){
    sshagent(['prod-server']) {
        sh '''
            ssh -o StrictHostKeyChecking=no -p 2222 farhan_maulana@172.17.240.38 "
                echo 'Deploy berhasil!'
            "
        '''
    }
}
}