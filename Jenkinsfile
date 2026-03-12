pipeline {
    agent {
        docker {
            image 'composer:2.7' // Jenkins akan menjalankan stage di dalam container ini
            args '-u root'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'php -v'
                sh 'composer --version'
                sh 'composer install'
            }
        }
        stage('Testing') {
            steps {
                sh 'echo "Ini adalah test"'
            }
        }
        stage("Deploy Prod") {
    steps {
        withEnv(["PROD_HOST=172.17.240.38"]) {
            sshagent(credentials: ['ssh-prod']) {
                sh '''
                    # Pastikan direktori .ssh ada dengan permission yang benar
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh
                    
                    # Ambil fingerprint host agar rsync tidak gagal karena security prompt
                    ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                    
                    # Jalankan rsync dengan verbose agar kita bisa lihat jika ada file yang gagal terkirim
                    rsync -avz --delete \
                        -e "ssh -o StrictHostKeyChecking=no" \
                        ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                        --exclude=.env \
                        --exclude=storage \
                        --exclude=.git \
                        --exclude=node_modules
                '''
            }
        }
    }
}
    }
}
