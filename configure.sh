apt-get install curl -y
export RAILS_ENV="production"
service mysql start
mysql -u root -p'' -h localhost -e "CREATE USER 'secprd' IDENTIFIED BY 'SeNh@F0rT3';"
mysql -u root -p'' -h localhost -e "GRANT USAGE ON *.* TO 'secprd'@localhost IDENTIFIED BY 'SeNh@F0rT3';"
mysql -u root -p'' -h localhost -e "GRANT ALL PRIVILEGES ON * . * TO 'secprd'@'localhost';" ; mysql -u root -p'' -h localhost -e "FLUSH PRIVILEGES;"
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
mysql -u root -p'' -h localhost -e "GRANT CREATE,DROP,DELETE,INSERT,SELECT,UPDATE ON * . * TO 'secprd'@'localhost';" ; mysql -u root -p'' -h localhost -e "FLUSH PRIVILEGES;"
rails server &
sleep 10
while true; do curl -X POST http://localhost:3000/users; let cnt++ ; if [[ "$cnt" -gt 1000 ]]; then break ; fi ;  done
mkdir /root/case1/ ; mkdir /root/case2/
cat /var/www/sec-app/log/production.log | grep "error creating" | awk '{print $11 '} > /root/case2/output.txt
apt-get install logrotate -y
touch /etc/logrotate.d/rails ; chmod 0644 /etc/logrotate.d/rails
echo '/var/www/sec-app/log/production.log {
    daily
    missingok
    rotate 30
    compress
    notifempty
}' >> /etc/logrotate.d/rails
