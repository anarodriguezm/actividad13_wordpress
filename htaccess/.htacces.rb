# BEGIN WordPress
# Las directivas (líneas) entre «BEGIN WordPress» y «END WordPress» son
# generadas dinámicamente y solo deberían ser modificadas mediante filtros de WordPress.
# Cualquier cambio en las directivas que hay entre esos marcadores serán sobrescritas.
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
