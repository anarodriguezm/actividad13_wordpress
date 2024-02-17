#!/bin/bash

# Paso 1: Actualización de repositorios
apt update

# Paso 2: Instalación de Apache2
apt install apache2 -y

# Paso 3: Instalación de PHP y módulos
apt install php libapache2-mod-php php-mysql -y

# Paso 4: Edición del archivo de configuración de Apache (000-default.conf)
echo '
<VirtualHost *:80>
#ServerName www.example.com
ServerAdmin webmaster@localhost
DocumentRoot /var/www/html
DirectoryIndex index.html index.php
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/000-default.conf

# Paso 5: Reinicio del servicio Apache2
systemctl restart apache2

# Paso 6: Creación de una página de prueba PHP
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

# Paso 7: Instalación de MariaDB
# Configurar la contraseña de root de MariaDB
debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password password $MARIADB_ROOT_PASSWORD"
debconf-set-selections <<< "mariadb-server-10.3 mysql-server/root_password_again password $MARIADB_ROOT_PASSWORD"
apt install -y mariadb-server mariadb-client

# Paso 8: Instalación de PhpMyAdmin
# Configurar la contraseña de PhpMyAdmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
# Establecemos las contraseñas para mariadb y phpmyadmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MARIADB_ROOT_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PASSWORD"
# Con esto seleccionamos la opcion que salia en grafico de apache2
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
# Realizamos la instalacion
apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl


