// node {
//     checkout scm
//     stage("Build"){
//         docker.image('composer:2.6').inside('-u root') {
//             sh 'rm -f composer.lock'
//             sh 'composer install'
//         }
//     }
//     stage("Testing"){
//         docker.image('ubuntu').inside('-u root') {
//             sh 'echo "Ini adalah test"'
//         }
//     }
//     stage("Deploy"){
//     sshagent(['ssh-prod']) {
//         sh '''
//             ssh -o StrictHostKeyChecking=no -p 22 kholzt@172.17.240.38 "
//                 echo 'Deploy berhasil!'
//             "
//         '''
//     }
// }
// }


node {
    def PROD_HOST = "172.17.240.38"
    def PROD_USER = "kholzt"
    def PROD_PATH = "/home/kholzt/prod.kelasdevops.xyz"

    stage("Checkout") {
        checkout scm
    }

    stage("Build") {
        docker.image('composer:2.6').inside('-u root') {
            sh '''
            rm -f composer.lock
            composer install
            '''
        }
    }

    stage("Testing") {
        docker.image('ubuntu').inside('-u root') {
            sh 'echo "Ini adalah test"'
        }
    }

   stage("Deploy"){
        // Gunakan image yang punya rsync
        docker.image('agung3wi/alpine-rsync:1.1').inside('--network host -u root') {
            sshagent(['ssh-prod']) {
                sh '''
                    mkdir -p ~/.ssh
                    ssh-keyscan -H 172.17.240.38 >> ~/.ssh/known_hosts
                    
                    # PERHATIKAN: User target adalah kholzt, path folder juga kholzt
                    rsync -avz --delete ./ kholzt@172.17.240.38:/home/kholzt/prod.kelasdevops.xyz/ \
                    --exclude=.env --exclude=storage --exclude=.git
                '''
            }
        }
    }
}