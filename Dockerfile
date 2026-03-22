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

CMD php artisan serve --host=0.0.0.0 --port=8000
