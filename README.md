# Instalación de WordPress

*En este documento ahora explicaremos como continuar con la instalacion partiendo de lo realizado en la actividad 1.3.1 de LAMP*

## Paso 1: Instalación de paquetes PHP necesarios

    Instala los paquetes necesarios:

    apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

![Texto alternativo](Captura12.png)

## Paso 2: Creación y configuración de la base de datos

Accede a MySQL como usuario root:
                
        mysql -u root -p

Crea una nueva base de datos llamada wordpress.

        CREATE DATABASE wordpress;

Selecciona la base de datos wordpress.

        USE wordpress;
Crea un nuevo usuario llamado wordpress con contraseña usuario@1.

    CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'usuario@1';



Otorga todos los privilegios al usuario wordpress para la base de datos wordpress.

        GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' WITH GRANT OPTION;

Limpia los privilegios para que surtan efecto.

    FLUSH PRIVILEGES;

![Texto alternativo](Captura13.png)

Sal de MySQL.

        QUIT;

## Paso 3: Configuración de Apache2

Editar el archivo 000-default.conf en el directorio de configuración de Apache.
Dentro del bloque VirtualHost, añade las siguientes directivas:

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        DirectoryIndex index.html index.php
        <Directory /var/www/html/>
            AllowOverride All
        </Directory>

![Texto alternativo](Captura14.png)

Activa el mod_rewrite de Apache2.

    a2enmod rewrite

Reinicia el servidor web Apache.

    systemctl restart apache2

## Paso 4: Descarga e instalación de WordPress

Instala el paquete wget.

        apt install wget -y

Descarga WordPress desde su sitio oficial.

    wget https://es.wordpress.org/latest-es_ES.zip -P /tmp

![Texto alternativo](Captura16.png)

Descomprime el archivo descargado.

        apt install unzip -y

Mueve los archivos de WordPress al directorio raíz del servidor web (/var/www/html).

        mv -f /tmp/wordpress/* /var/www/html

![Texto alternativo](paso17.png)

Cambia el propietario del directorio raíz de WordPress al usuario y grupo www-data.

        sudo chown -R www-data:www-data /var/www/html

Reinicia el servidor web Apache.

        sudo systemctl restart apache2

Termina de configurar WordPress a través de un navegador web. Abre un navegador web y escribe la dirección IP del servidor.

    http://localhost/

![Texto alternativo](cap4.png)
