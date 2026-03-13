node {
    def PROD_HOST = "172.17.240.38"
    def PROD_USER = "kholzt"
    def PROD_PATH = "/home/kholzt/prod.kelasdevops.xyz"

    stage("Checkout") {
        checkout scm
    }

    stage("Build") {
        // Tetap gunakan composer
        docker.image('composer:2.6').inside('-u root') {
            sh '''
            composer install --no-dev --optimize-autoloader
            '''
        }
    }

    stage("Deploy") {
        // Gunakan image yang sudah ada rsync & ssh
        docker.image('instrumentisto/rsync-ssh').inside('-u root') {
            sshagent(['ssh-prod']) {
                sh """
                mkdir -p ~/.ssh
                chmod 700 ~/.ssh
                ssh-keyscan -H ${PROD_HOST} >> ~/.ssh/known_hosts
                
                rsync -avz --delete ./ ${PROD_USER}@${PROD_HOST}:${PROD_PATH}/ \
                --exclude=.env --exclude=storage --exclude=.git
                """
            }
        }
    }
}
