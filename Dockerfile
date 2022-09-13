FROM php:8.1.9-fpm
RUN apt-get update && apt-get install -y git procps inetutils-ping net-tools cmake \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-5.3.7 \
    && docker-php-ext-install pdo pdo_mysql mysqli zip grpc \
    && docker-php-ext-enable redis

RUN git clone -b v1.48.1 https://github.com/grpc/grpc \
    && cd grpc \
    && git submodule update --init \
    && mkdir -p cmake/build \
    && cd cmake/build \
    && cmake ../.. \
    && make protoc grpc_php_plugin \
    && COPY --from=build /usr/src/app/grpc/cmake/build/grpc_php_plugin /usr/bin/ \
    && COPY --from=build /usr/src/app/grpc/cmake/build/third_party/protobuf/protoc* /usr/bin/ \
    && rm -rf ./grpc