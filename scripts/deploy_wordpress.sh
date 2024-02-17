#!/bin/bash
# Creacion y configuracion de la base de datos para wordpress

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY 
'$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO 
$WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Paso 3: Configuración de Apache2
# Añadir directivas al archivo de configuración de Apache (000-default.conf)
sed -i '/DocumentRoot \/var\/www\/html/a\
\
  <Directory /var/www/html/>\
    AllowOverride All\
  </Directory>' /etc/apache2/sites-available/000-default.conf

# Activar el mod_rewrite para enlaces permanentes de WordPress
a2enmod rewrite

# Reiniciar el servidor web Apache
systemctl restart apache2

# Paso 4: Descarga e instalación de WordPress
# Instalación de wget para descargar los archivos de WordPress
apt install -y wget

# Descargar WordPress
wget https://es.wordpress.org/latest-es_ES.zip -P /tmp

# Instalación de unzip para descomprimir el archivo de WordPress
apt install -y unzip

# Descomprimir WordPress y mover los archivos al directorio de Apache
unzip /tmp/latest-es_ES.zip -d /tmp
mv -f /tmp/wordpress/* /var/www/html

# Cambiar el propietario de los archivos de WordPress
chown -R www-data:www-data /var/www/html

# Reiniciar el servidor web Apache
systemctl restart apache2

# Preparar la configuración para los enlaces permanentes de WordPress
echo "
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
" > /var/www/html/.htaccess

# Crear el archivo de configuración wp-config.php
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Configurar las variables de configuración en el archivo wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php


