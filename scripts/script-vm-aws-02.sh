
#instalacao LAMP

sudo apt update -y
sudo apt install apache2 -y
sudo apt install mysql-server -y
sudo apt install php php-mysql libapache2-mod-php php-cli -y
sudo ufw allow in "Apache Full"
sudo chmod -R 0755 /var/www/html/
sudo systemctl enable apache2
sudo systemctl start apache2
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php

sudo apt install phpmyadmin php-mbstring php-gettext

sudo phpenmod mcrypt
sudo phpenmod mbstring

sudo systemctl restart apache2
