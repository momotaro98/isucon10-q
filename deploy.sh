#!/bin/bash

# source $HOME/.bash_profile $HOME/.bashrc

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo 'Restarting Go...'
cd $DIR/webapp/go/
/home/isucon/local/go/bin/go build -o isuumo
sudo systemctl stop isuumo.go.service
cp isuumo /home/isucon/isuumo/webapp/go/
cd $DIR
sudo systemctl restart isuumo.go.service
echo 'Restarted!'

sudo cp $DIR/systemd/* /etc/systemd/system/
sudo systemctl daemon-reload

echo 'Updating config file...'
sudo cp "$DIR/nginx.conf" /etc/nginx/nginx.conf
# sudo cp "$DIR/redis.conf" /etc/redis/redis.conf
sudo cp "$DIR/mysqld.cnf" /etc/mysql/mysql.conf.d/mysqld.cnf
echo 'Updated config file!'

echo 'Restarting services...'
# sudo systemctl restart redis.service
sudo systemctl restart mysql.service
sudo systemctl restart nginx.service
echo 'Restarted!'

echo 'Rotating files'
sudo bash -c 'cp /var/log/nginx/access.log /var/log/nginx/access.log.$(date +%s) && echo > /var/log/nginx/access.log'
sudo bash -c 'cp /tmp/mysql-slow.sql /tmp/mysql-slow.sql.$(date +%s).$(git rev-parse HEAD) && echo > /tmp/mysql-slow.sql'
echo 'Rotated!'
