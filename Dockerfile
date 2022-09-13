FROM debian:11.5 AS build
RUN apt-get update && apt-get install -y git cmake
WORKDIR /usr/src/app
RUN git clone -b v1.48.1 https://github.com/grpc/grpc
RUN cd grpc
RUN git submodule update --init
RUN mkdir -p cmake/build
RUN cd cmake/build
RUN cmake ../..
RUN make protoc grpc_php_plugin

FROM php:8.1.9-fpm
RUN apt-get update && apt-get install -y git procps inetutils-ping net-tools \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-5.3.7 \
    && docker-php-ext-install pdo pdo_mysql mysqli zip grpc \
    && docker-php-ext-enable redis \
    && curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && chmod +x /usr/bin/composer \
    && composer self-update 2.3.10 \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && COPY --from=build /usr/src/app/grpc/cmake/build/grpc_php_plugin /usr/bin/ \
    && COPY --from=build /usr/src/app/grpc/cmake/build/third_party/protobuf/protoc* /usr/bin/

