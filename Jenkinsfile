node {
    def PROD_HOST = "172.17.240.1"
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

    stage("Deploy") {
        // Menggunakan --network host agar container bisa melihat IP Host (WSL)
        docker.image('agung3wi/alpine-rsync:1.1').inside('--network host -u root') {
            sshagent(['ssh-prod']) {
                sh """
                    # Pasang ssh-client jika belum ada
                    apk add --no-cache openssh-client || true
                    
                    # Buat folder .ssh (Gunakan '#' untuk komentar, BUKAN '//')
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh
                    
                    # Scan host agar tidak ditanya yes/no
                    ssh-keyscan -H ${PROD_HOST} > ~/.ssh/known_hosts
                    
                    # Jalankan rsync menggunakan variabel yang sudah didefinisikan
                    rsync -avz --delete ./ ${PROD_USER}@${PROD_HOST}:${PROD_PATH}/ \
                    --exclude=.env --exclude=storage --exclude=.git
                """
            }
        }
    }
}