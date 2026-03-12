pipeline {
    agent {
        docker {
            image 'composer:2.7'
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
                    // Gunakan ID kredensial yang sesuai di Jenkins kamu (ssh-prod)
                    sshagent(credentials: ['ssh-prod']) {
                        sh '''
                            # 1. Install rsync dan openssh-client karena image composer tidak memilikinya
                            apk add --no-cache rsync openssh-client

                            # 2. Persiapan direktori SSH
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh
                            
                            # 3. Ambil fingerprint host (Gunakan -v untuk debugging jika gagal)
                            ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                            chmod 644 ~/.ssh/known_hosts
                            
                            # 4. Jalankan rsync
                            # Ditambahkan flag -v (verbose) agar log terlihat jelas
                            rsync -avz --delete \
                                -e "ssh -o StrictHostKeyChecking=no" \
                                ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                                --exclude=.env \
                                --exclude=storage \
                                --exclude=.git \
                                --exclude=node_modules \
                                --exclude=vendor
                        '''
                    }
                }
            }
        }
    }
}
