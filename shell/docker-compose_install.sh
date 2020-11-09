#!/bin/bash
# docker-compose 安装
# author: yundi.xxii <yundi.xxii@outlook.com>

set -e

VERSION=1.27.4
ADDR=https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-Linux-x86_64
SHA_ADDR=https://github.com/docker/compose/releases/download/${VERSION}//docker-compose-Linux-x86_64.sha256
SHA_FILE=sha256

# 下载docker-compose
wget $ADDR
wget $SHA_ADDR -O $SHA_FILE
sha256sum -c $SHA_FILE