#!/bin/bash
sudo su
sudo yum install -y nodejs
sudo yum install -y git
sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
systemctl status nginx
cd /usr/share/nginx/html
git clone https://github.com/Ram1814/TaskManager-API.git
cd TaskManager-API
sudo echo "MONGO_URI = mongodb+srv://Ram1814:ram2002@mycluster.izl3iaq.mongodb.net/MyTaskAPI?retryWrites=true&w=majority" >> .env
npm install
npm install -g pm2 
pm2 start app.js --name=TaskManager-API
pm2 save     
pm2 startup


cd /etc/nginx/

sudo su
rm -f nginx.conf 

sudo echo "user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
      include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
         location / {
        proxy_pass http://localhost:3000;
       }

    }
}   " >> nginx.conf


      


sudo nginx -t
sudo service nginx restart
cd /usr/share/nginx/html/TaskManager-API
pm2 start app.js --name=TaskManager-API

