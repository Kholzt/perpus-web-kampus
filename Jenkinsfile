


// PUNYA KHOLIT
node {
    checkout scm

    stage("Build") {
        // Menggunakan Docker agar tidak perlu instal PHP di mesin Jenkins
        docker.image('composer:2.7').inside('-u root') {
            sh 'php -v'
            sh 'composer --version'
            sh 'composer install --ignore-platform-reqs'
        }
    }

    stage("Testing") {
        sh 'echo "Ini adalah test"'
    }

stage("Deploy Prod") {
    docker.image('instrumentisto/rsync-ssh').inside('-u root') {
        withEnv(["PROD_HOST=172.17.240.38"]) {
            sshagent(credentials: ['ssh-prod']) {
                sh '''
                    # Pastikan direktori ada
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh

                    # Ambil key server dan masukkan ke known_hosts
                    # Jika gagal (timeout), tampilkan error tapi jangan hentikan agent dulu
                    ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts || echo "Gagal melakukan scan host"

                    # Cek apakah rsync bisa berjalan
                    # Tambahkan -e "ssh -p 22" untuk memastikan rsync menggunakan SSH
                    rsync -ravz --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                    --exclude=.env \
                    --exclude=storage \
                    --exclude=.git
                '''
            }
        }
    }
}
}
