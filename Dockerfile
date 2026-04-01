FROM php:8.2-cli

WORKDIR /var/www

# Install dependency Linux + PHP extension
RUN apt-get update && apt-get install -y \
    git curl unzip libxml2-dev \
    && docker-php-ext-install xml

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install
RUN mkdir -p /var/www/html/storage/framework/views \
             /var/www/html/storage/framework/sessions \
             /var/www/html/storage/framework/cache \
             /var/www/html/bootstrap/cache

# Berikan kepemilikan ke user www-data (user standar PHP-FPM)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
CMD php artisan serve --host=0.0.0.0 --port=8000
