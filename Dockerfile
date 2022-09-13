FROM debian:11.5
WORKDIR /data
RUN apt-get update && apt-get install -y git procps inetutils-ping net-tools cmake
RUN git clone -b v1.48.1 https://github.com/grpc/grpc \
&& cd grpc \
&& git submodule update --init \
&& mkdir -p cmake/build \
&& cd cmake/build \
&& cmake ../.. \
&& make protoc grpc_php_plugin \
&& cp /data/grpc/cmake/build/grpc_php_plugin /usr/bin/ \
&& cp /data/grpc/cmake/build/third_party/protobuf/protoc* /usr/bin/ \
&& rm -rf /data/grpc
