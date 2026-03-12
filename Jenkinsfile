pipeline {
    agent {
        docker {
            image 'composer:2.7'
            args '--entrypoint="" -u root'
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
                            apk add --no-cache rsync openssh-client

                            mkdir -p ~/.ssh
                            chmod 700 ~/.ssh

                            ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                            chmod 644 ~/.ssh/known_hosts

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
