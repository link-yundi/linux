#!/bin/bash
# harbor安装
# author: yundi.xxii <yundi.xxii@outlook.com>

set -e

# harbor版本
VERSION=v2.1.1
IP=$(curl ip.sb)

if [ ! -d $PWD/harbor ]
then
	mkdir $PWD/harbor
fi
cd harbor

# 下载安装包
if [ ! -e harbor-offline-installer-${VERSION}.tgz ]
then
	wget https://github.com/goharbor/harbor/releases/download/${VERSION}/harbor-offline-installer-${VERSION}.tgz
fi
if [ ! -e md5sum ]
then
	wget https://github.com/goharbor/harbor/releases/download/${VERSION}/md5sum
fi

# 校验
md5sum -c md5sum | grep harbor-offline-installer-${VERSION}.tgz:

# 解压
tar -zxvf harbor-offline-installer-${VERSION}.tgz && cd harbor
cp harbor.yml.tmpl harbor.yml

sed -i 's/https/\#https/g' harbor.yml
sed -i 's/port: 443/\#port: 443/g' harbor.yml
sed -i 's/certificate/\#certificate/g' harbor.yml
sed -i 's/private_key/\#private_key/g' harbor.yml


# 修改配置文件
sed -i "s/hostname: reg.mydomain.com/hostname: ${IP}/g" harbor.yml
sed -i "s/port: 80/port: 10080/g" harbor.yml


bash prepare
bash install.sh
