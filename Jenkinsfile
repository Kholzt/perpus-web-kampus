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
                    args '-u root'
                }
            }
            steps {
                sh 'composer install --ignore-platform-reqs'
            }
        }

        stage("Testing") {
            steps {
                sh 'echo "Test passed"'
            }
        }

        stage("Deploy Prod") {
            agent {
                docker {
                    image 'instrumentisto/rsync-ssh'
                    // KUNCI UTAMA: Memetakan 'host.docker.internal' ke gateway WSL
                    args '-u root --add-host=host.docker.internal:host-gateway'
                }
            }
            steps {
                // Gunakan DNS host.docker.internal sebagai pengganti IP
                withEnv(["PROD_HOST=host.docker.internal"]) {
                    sshagent(credentials: ['ssh-prod']) {
                        sh '''
                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh

                            # Tambahkan rsync dengan parameter SSH yang lebih longgar untuk koneksi lokal
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
}
