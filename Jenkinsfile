


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
        sshagent(credentials: ['kholzt']) {
            sh '''
                # Install rsync jika belum ada
                if ! command -v rsync > /dev/null; then
                    echo "Installing rsync..."
                    apt-get update && apt-get install -y rsync
                fi

                mkdir -p ~/.ssh
                ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts
                
                rsync -rav --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                --exclude=.env --exclude=storage --exclude=.git
            '''
        }
    }
}
}
