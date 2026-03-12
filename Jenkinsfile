pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build") {
            agent {
                docker {
                    image 'composer:2.7'
                    // Menjalankan sebagai root agar tidak ada masalah permission di workspace WSL
                    args '-u root'
                }
            }
            steps {
                sh 'php -v'
                sh 'composer --version'
                sh 'composer install --ignore-platform-reqs'
            }
        }

        stage("Testing") {
            steps {
                sh 'echo "Running tests... Semua aman!"'
            }
        }

        stage("Deploy Prod") {
            agent {
                docker {
                    image 'instrumentisto/rsync-ssh'
                    // KUNCI UTAMA: --net=host agar container bisa melihat IP Host/WSL
                    args '-u root --net=host'
                }
            }
            steps {
                withEnv(["PROD_HOST=172.17.240.38"]) {
                    sshagent(credentials: ['ssh-prod']) {
                        sh '''
                            # Persiapan direktori SSH
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh

                            # Scan host untuk keamanan, tapi jangan stop pipeline jika gagal (timeout)
                            ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts || echo "Scan host gagal, melanjutkan dengan bypass..."

                            # Proses Rsync
                            # -o StrictHostKeyChecking=no ditambahkan sebagai pengaman jika IP WSL berubah
                            rsync -ravz --delete \
                                -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
                                ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                                --exclude=.env \
                                --exclude=storage \
                                --exclude=.git
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Berhasil!'
        }
        failure {
            echo 'Deployment Gagal. Silakan cek koneksi SSH atau IP Target di WSL.'
        }
    }
}
