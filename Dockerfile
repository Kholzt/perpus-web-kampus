



# 1. Ganti dari -cli ke -fpm (FastCGI Process Manager)
FROM php:8.2-fpm

# 2. Sesuaikan WORKDIR dengan docker-compose (/var/www/html)
WORKDIR /var/www/html

# 3. Install dependency (tambahkan libpng-dev dll jika Laravel butuh)
RUN apt-get update && apt-get install -y \
    git curl unzip libxml2-dev libpng-dev libonig-dev \
    && docker-php-ext-install xml pdo_mysql mbstring gd

# 4. Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 5. Copy file project
COPY . .

# 6. Install dependencies Laravel
RUN composer install --no-dev --optimize-autoloader

# 7. Berikan izin akses folder (PENTING untuk Laravel di Docker)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN mkdir -p /var/www/html/storage/framework/views \
             /var/www/html/storage/framework/sessions \
             /var/www/html/storage/framework/cache \
             /var/www/html/bootstrap/cache

# Berikan kepemilikan ke user www-data (user standar PHP-FPM)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
# 8. EXPOSE port 9000 (port standar PHP-FPM)
EXPOSE 9000

# 9. Jalankan php-fpm (Hapus php artisan serve)
CMD ["php-fpm"]