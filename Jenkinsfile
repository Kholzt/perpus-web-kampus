


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
    withEnv(["PROD_HOST=172.17.240.38"]) {
        // Ganti 'ssh-prod' dengan ID kredensial Anda (tadi Anda sebut 'kholzt')
        sshagent(credentials: ['ssh-prod']) { 
            sh '''
                # Buat folder .ssh dengan izin akses yang tepat
                mkdir -p ~/.ssh
                chmod 700 ~/.ssh

                # Hapus kunci lama agar tidak duplikat, lalu scan ulang
                ssh-keygen -R "$PROD_HOST" || true
                ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                chmod 644 ~/.ssh/known_hosts

                # Eksekusi rsync
                rsync -rav --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                --exclude=.env \
                --exclude=storage \
                --exclude=.git
            '''
        }
    }
}
}
