node {
    checkout scm
    
    stage("Build"){
        docker.image('composer:2.7').inside('-u root') {
            sh 'rm -f composer.lock'
            sh 'composer install'
        }
    }

    stage("Testing"){
        docker.image('ubuntu').inside('-u root') {
            sh 'echo "Ini adalah test"'
        }
    }

    stage("Deploy"){
        // --add-host memetakan 'host.docker.internal' ke IP gateway WSL kamu
        docker.image('agung3wi/alpine-rsync:1.1').inside('--add-host=host.docker.internal:host-gateway -u root') {
            // Gunakan host.docker.internal sebagai pengganti IP statis
            withEnv(['PROD_HOST=127.0.0.1']) {
                sshagent (credentials: ['ssh-prod']) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        
                        # Menghapus entri lama jika ada dan mengambil fingerprint baru
                        ssh-keyscan -H "$PROD_HOST" > ~/.ssh/known_hosts
                        
                        # Jalankan rsync
                        rsync -rav --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ \
                        --exclude=.env --exclude=storage --exclude=.git
                    '''
                }
            }
        }
    }
}
