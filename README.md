## 构建镜像

第一步：构建基础镜像（包含grpc相关文件），也可以用我构建好的：`registry.cn-hangzhou.aliyuncs.com/cuiw/php-grpc:41b677450444b690ebee6fcf2d45cad2c2de4ca8`
```
docker build -f Dockerfile -t php-grpc:8.1.9-fpm-v1.0 .
```

第二步：构建常用镜像

`Dockerfile.demo` 详解：
第一阶段：加载基础镜像

第二阶段：安装所需扩展，并复制grpc相关文件
```
docker build -f Dockerfile.demo -t php:8.1.9-fpm-demo-v1.0 .
```

## 参考
https://github.com/grpc/grpc/blob/v1.60.0/src/php/README.md