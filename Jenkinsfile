node {
 checkout scm
 // deploy env dev
 stage("Build"){
 docker.image('shippingdocker/php-composer:7.4').inside('-u root') {
 sh 'rm -f composer.lock'
 sh 'composer install'
 }
 }
 // Testing
 stage("Testing"){
 docker.image('ubuntu').inside('-u root') {
 sh 'echo "Ini adalah test"'
 }
 }
 // deploy env prod
 stage("Deploy"){
 docker.image('agung3wi/alpine-rsync:1.1').inside('-u root') {
 // Pastikan PROD_HOST didefinisikan di sini agar terbaca oleh shell
 withEnv(['PROD_HOST=172.17.240.38']) {
 sshagent (credentials: ['ssh-prod']) {
 sh 'mkdir -p ~/.ssh'
 sh 'ssh-keyscan -H "$PROD_HOST" >> ~/.ssh/known_hosts'
 // Saya sesuaikan ke user kholzt dan path ./ sesuai progres sebelumnya
 sh "rsync -rav --delete ./ kholzt@$PROD_HOST:/home/kholzt/prod.kelasdevops.xyz/ --exclude=.env --exclude=storage --exclude=.git"
 }
 }
 }
 }
}
