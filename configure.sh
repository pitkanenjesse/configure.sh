#!/bin/bash

apt-get install curl -y
export RAILS_ENV="production"
service mysql start
mysql -u root -p' ' -h localhost -e "CREATE USER 'secprd' IDENTIFIED BY 'SeNh@F0rT3';"
mysql -u root -p' ' -h localhost -e "GRANT USAGE ON *.* TO 'secprd'@localhost IDENTIFIED BY 'SeNh@F0rT3';"
mysql -u root -p' ' -h localhost -e "GRANT ALL PRIVILEGES ON * . * TO 'secprd'@'localhost';" ; mysql -u root -p' ' -h localhost -e "FLUSH PRIVILEGES;"
echo 'production:
  adapter: mysql2
  encoding: utf8
  timeout: 5000
  pool: 10
  host: localhost
  database: sec-app_prod
  username: secprd
  password: SeNh@F0rT3' > /var/www/sec-app/config/database.yml
bundle exec rails db:setup
mysql -u root -p' ' -h localhost -e "GRANT CREATE,DROP,DELETE,INSERT,SELECT,UPDATE ON * . * TO 'secprd'@'localhost';" ; mysql -u root -p' ' -h localhost -e "FLUSH PRIVILEGES;"
rails server &
sleep 10
while true; do curl -X POST http://localhost:3000/users; let cnt++ ; if [[ "$cnt" -gt 1000 ]]; then break ; fi ;  done
mkdir /root/case1/ ; mkdir /root/case2/
cat /var/www/sec-app/log/production.log | grep "error creating" | awk '{print $11 }' > /root/case2/output.txt
apt-get install logrotate -y
touch /etc/logrotate.d/rails ; chmod 0644 /etc/logrotate.d/rails
echo '/var/www/sec-app/log/production.log {
    daily
    missingok
    rotate 30
    compress
    notifempty
}' >> /etc/logrotate.d/rails



echo 'O problema foi resolvido utilizando apenas uma linha, tendo a premissa de que tenha o docker e o git instalado no docker host e que contenha acesso direto a internet, sem proxy.

Ferramentas utilizadas foram o GitHub, Logrotate, Puma e Curl.

Poderia ter sido utilizdo um Ansible para efetuar a configuração dos servidores e um gerenciador de repositório como o Nexus, nesse caso foi utilizado apenas um script que está armazenado no GitHub.

Segue os comandos comentados do passo a passo:

-Instalar o curl para efetuar as chamadas posteriormente:
apt-get install curl -y

-Expotrar a variável:
export RAILS_ENV="production"

-Iniciar o mysql
service mysql start

-Criar usuário de banco de dados:
mysql -u root -p -h localhost -e "CREATE USER sec-app-user_prd IDENTIFIED BY SeNh@F0rT3;"

-Dar permissão ao usuário no bd:
mysql -u root -p -h localhost -e "GRANT USAGE ON *.* TO sec-app-user_prd@localhost IDENTIFIED BY SeNh@F0rT3;"

-Dar as permissões para execução do comando de criação do banco de dados:
mysql -u root -p -h localhost -e "GRANT ALL PRIVILEGES ON * . * TO db-username@localhost;" ; mysql -u root -p -h localhost -e "FLUSH PRIVILEGES;"

-Alterar o arquivo /var/www/sec-app/config/database.yml (eu sei, isso é meio burro, o user e pass deveriam ser variaveis e serem passados durante a execução Jenkins credentials ou solicitando input):

echo production:
  adapter: mysql2
  encoding: utf8
  timeout: 5000
  pool: 10
  host: localhost
  database: sec-app_prod
  username: sec-app-user_prd
  password: SeNh@F0rT3 > /var/www/sec-app/config/database.yml


-E executar o comando:
bundle exec rails db:setup

-Dar as permissão corretas para execução no BD: 
mysql -u root -p -h localhost -e "GRANT CREATE,DROP,DELETE,INSERT,SELECT,UPDATE ON * . * TO db-username@localhost;" ; mysql -u root -p -h localhost -e "FLUSH PRIVILEGES;"

-Iniciar o webserver puma na pasta da aplicação:
rails server &

-Chamada para a criar a massa de dados 1000x:
while true; do curl -X POST http://localhost:3000/users; let cnt++ ; if [[ "$cnt" -gt 1000 ]]; then break ; fi ;  done

-Criar as pastas do case:
mkdir /root/case1/ ; mkdir /root/case2/

-Criar a saída do log apenas com usuários não criados, jogando para a saída /root/case2/output.txt:
cat /var/www/sec-app/log/production.log | grep "error creating" | awk {print $11 } > /root/case2/output.txt

-Instalar o logrotate e configurar:
apt-get install logrotate -y

-Criar o arquivo em /etc/logrotate.d/rails e dar a permissão correta:
touch /etc/logrotate.d/rails ; chmod 0644 /etc/logrotate.d/rails

-Inserir as configurações no arquivo criado no comando anterior: 

echo /var/www/sec-app/log/production.log {
    daily
    missingok
    rotate 30
    compress
    notifempty
} >> /etc/logrotate.d/rails' > /root/case1/README.md

echo 'Para gerar a massa de dados foi criado um loop que quebra após rodar 1000 vezes com o comando curl efetuando um POST, utilizando 1 linha:
while true; do curl -X POST http://localhost:3000/users; let cnt++ ; if [[ "$cnt" -gt 1000 ]]; then break ; fi ;  done

-Para efetuar o filtro, foi utilizado o seguinte comando:
cat /var/www/sec-app/log/production.log | grep "error creating" | awk {print $11 } > /root/case2/output.txt' > /root/case2/README.md 

echo
echo "Segue usuários que deram erro e não foram inserdos na base de dados:"
cat /root/case2/output.txt
echo
echo "Segue passo a passo do case1:"
cat /root/case1/README.md
echo
echo "Segue passo a passo do case2":
cat /root/case2/README.md
