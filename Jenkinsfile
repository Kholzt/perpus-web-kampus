


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
    // Menggunakan docker untuk menjalankan rsync & ssh
    docker.image('instrumentisto/rsync-ssh').inside('-u root') {
        withEnv(["PROD_HOST=172.17.240.38"]) {
            sshagent(credentials: ['ssh-prod']) {
                sh '''
                    # Persiapan folder SSH di dalam container docker
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh
                    
                    # Scan host agar tidak ditanya fingerprint
                    ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                    
                    # Jalankan rsync
                    rsync -rav --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                    --exclude=.env --exclude=storage --exclude=.git
                '''
            }
        }
    }
}
}
