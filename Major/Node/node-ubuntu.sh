# video link = https://www.youtube.com/watch?v=yhiuV6cqkNs
# github link - https://github.com/saasscaleup/nodejs-ssl-server
sudo su
sudo apt update
sudo apt upgrade
sudo apt install -y git htop wget
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm --version
nvm install --lts # Latest stable node js server version
node --version
npm -v
cd /home/ubuntu
git clone https://github.com/rajeev-007-glitch/Task-Manager-API.git
cd Task-Manager-API
npm i
echo "MONGO_URI=<insert mongo URI>" > .env
npm install -g pm2 # may require sudo
pm2 start app.js --name=Task-Manager-API
pm2 save     # saves the running processes
                  # if not saved, pm2 will forget
                  # the running apps on next boot
pm2 startup # starts pm2 on computer boot
sudo apt install nginx
sudo su
rm /etc/nginx/sites-available/default
echo "##
        # You should look at the following URL's in order to grasp a solid understanding
        # of Nginx configuration files in order to fully unleash the power of Nginx.
        # https://www.nginx.com/resources/wiki/start/
        # https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
        # https://wiki.debian.org/Nginx/DirectoryStructure
        #
        # In most cases, administrators will remove this file from sites-enabled/ and
        # leave it as reference inside of sites-available where it will continue to be
        # updated by the nginx packaging team.
        #
        # This file will automatically load configuration files provided by other
        # applications, such as Drupal or Wordpress. These applications will be made
        # available underneath a path with that package name, such as /drupal8.
        #
        # Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
        ##

        # Default server configuration
        #
        server {
                listen 80 default_server;
                listen [::]:80 default_server;

                # SSL configuration
                #
                # listen 443 ssl default_server;
                # listen [::]:443 ssl default_server;
                #
                # Note: You should disable gzip for SSL traffic.
                # See: https://bugs.debian.org/773332
                #
                # Read up on ssl_ciphers to ensure a secure configuration.
                # See: https://bugs.debian.org/765782
                #
                # Self signed certs generated by the ssl-cert package
                # Don't use them in a production server!
                #
                # include snippets/snakeoil.conf;

                root /home/ubuntu/Task-Manager-API;

                # Add index.php to the list if you are using PHP
                index index.html index.htm index.nginx-debian.html;

                server_name _;

                location / {
                        # First attempt to serve request as file, then
                        # as directory, then fall back to displaying a 404.
                        # try_files $uri $uri/ =404;
                        proxy_pass http://localhost:3000; #whatever port your app runs on
                        proxy_http_version 1.1;
                        proxy_set_header Upgrade $http_upgrade;
                        proxy_set_header Connection 'upgrade';
                        proxy_set_header Host $host;
                        proxy_cache_bypass $http_upgrade;

                }

                # pass PHP scripts to FastCGI server
                #
                #location ~ \.php$ {
                #       include snippets/fastcgi-php.conf;
                #
                #       # With php-fpm (or other unix sockets):
                #       fastcgi_pass unix:/run/php/php7.4-fpm.sock;
                #       # With php-cgi (or other tcp sockets):
                #       fastcgi_pass 127.0.0.1:9000;
                #}

                # deny access to .htaccess files, if Apache's document root
                # concurs with nginx's one
                #
                #location ~ /\.ht {
                #       deny all;
                #}
        }


        # Virtual Host configuration for example.com
        #
        # You can move that to a different file under sites-available/ and symlink that
        # to sites-enabled/ to enable it.
        #
        #server {
        #       listen 80;
        #       listen [::]:80;
        #
        #       server_name example.com;
        #
        #       root /var/www/example.com;
        #       index index.html;
        #
        #       location / {
        #               try_files $uri $uri/ =404;
        #       }
    #}" > /etc/nginx/sites-available/default
sudo nginx -t
sudo service nginx restart
