


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
      withEnv(["PROD_HOST=172.25.46.154"]) {
        sshagent(credentials: ['ssh-prod']) {
          sh 'mkdir -p ~/.ssh'
          sh 'ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts'
          sh 'rsync -rav --delete ./ alexr@$PROD_HOST:/home/alexr/prod.kelasdevops.xyz/ --exclude=.env --exclude=storage --exclude=.git'
        }
    }
  }
}
