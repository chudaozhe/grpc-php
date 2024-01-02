FROM php:8.1.9-fpm
RUN apt-get update && apt-get install -y cmake git \
    && git clone -b v1.60.0 https://github.com/grpc/grpc \
    && cd grpc \
    && git submodule update --init \
    && mkdir -p cmake/build \
    && cd cmake/build \
    && cmake ../.. \
    && make protoc grpc_php_plugin \
    && cp third_party/protobuf/protoc /usr/bin/ \
    && cp grpc_php_plugin /usr/bin/ \
    && pecl install grpc protobuf \
    && docker-php-ext-enable grpc protobuf
