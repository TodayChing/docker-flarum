FROM php:5-apache
RUN apt-get update
RUN apt-get install -y libpng-dev zip git
RUN docker-php-ext-install mbstring pdo_mysql gd

WORKDIR /var/www
RUN php -r "readfile('https://getcomposer.org/installer');" | php
RUN mkdir flarum; cd flarum; php ../composer.phar create-project flarum/flarum . --no-interaction --stability=beta --prefer-source
ADD flarum.conf /etc/apache2/sites-enabled/
RUN chown -R www-data:www-data flarum

#extensions
RUN cd flarum; php ../composer.phar require vingle/flarum-configure-smtp
ADD https://github.com/s9e/flarum-ext-mediaembed/releases/download/0.3.0/s9e-mediaembed-0.3.0.zip /var/www/flarum/extensions
RUN cd extensions; unzip s9e-mediaembed-0.3.0.zip

EXPOSE 80
CMD apache2-foreground
