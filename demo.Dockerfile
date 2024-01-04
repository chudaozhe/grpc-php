FROM registry.cn-hangzhou.aliyuncs.com/cuiw/grpc-php:41b677450444b690ebee6fcf2d45cad2c2de4ca8 AS build

FROM composer:2.3.10 as composer

FROM php:8.1.9-fpm
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y git procps inetutils-ping net-tools \
#    && curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
#    && chmod +x /usr/bin/composer \
#    && composer self-update 2.3.10 \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

COPY --from=build /usr/bin/protoc /usr/bin/
COPY --from=build /usr/bin/grpc_php_plugin /usr/bin/
COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20210902/grpc.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/
COPY --from=build /usr/local/lib/php/extensions/no-debug-non-zts-20210902/protobuf.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/
COPY --from=build /usr/local/etc/php/conf.d/docker-php-ext-grpc.ini /usr/local/etc/php/conf.d/
COPY --from=build /usr/local/etc/php/conf.d/docker-php-ext-protobuf.ini /usr/local/etc/php/conf.d/
