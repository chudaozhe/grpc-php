FROM php:8.1.9-fpm
RUN apt-get update && apt-get install -y git procps inetutils-ping net-tools cmake \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev
RUN git clone -b v1.48.1 https://github.com/grpc/grpc \
    && cd grpc \
    && git submodule update --init \
    && mkdir -p cmake/build \
    && cd cmake/build \
    && cmake ../.. \
    && make protoc grpc_php_plugin \
    && cp /var/www/html/grpc/cmake/build/grpc_php_plugin /usr/bin/ \
    && cp /var/www/html/grpc/cmake/build/third_party/protobuf/protoc* /usr/bin/ \
    && rm -rf ./grpc \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-5.3.7 \
    && docker-php-ext-install pdo pdo_mysql mysqli zip grpc \
    && docker-php-ext-enable redis \
    && curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && chmod +x /usr/bin/composer \
    && composer self-update 2.4.1 \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
