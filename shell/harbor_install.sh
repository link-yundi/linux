#!/bin/bash
# harbor安装
# author: yundi.xxii <yundi.xxii@outlook.com>

set -e

# harbor版本
VERSION=v2.1.1

# 自定义主机域名
DOMAIN=hub.xxii.com
DOMAIN2=hub.xxii
PROVINCE=Guangdong
CITY=Guangzhou
ORGANIZATION=xxii

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

# 自信任文件
if [ ! -d /data/cert ]
then
	mkdir -p /data/cert
fi

if [ ! -d /etc/docker/certs.d/${DOMAIN} ]
then
	mkdir -p /etc/docker/certs.d/${DOMAIN}
fi

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=${PROVINCE}/L=${CITY}/O=${ORGANIZATION}/OU=Personal/CN=${DOMAIN}" \
 -key ca.key \
 -out ca.crt

openssl genrsa -out ${DOMAIN}.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=${PROVINCE}/L=${CITY}/O=${ORGANIZATION}/OU=Personal/CN=${DOMAIN}" \
    -key ${DOMAIN}.key \
    -out ${DOMAIN}.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=${DOMAIN}
DNS.2=${DOMAIN2}
DNS.3=localhost
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in ${DOMAIN}.csr \
    -out ${DOMAIN}.crt

cp ${DOMAIN}.crt /data/cert/
cp ${DOMAIN}.key /data/cert/

openssl x509 -inform PEM -in ${DOMAIN}.crt -out ${DOMAIN}.cert
cp ${DOMAIN}.cert /etc/docker/certs.d/${DOMAIN}/
cp ${DOMAIN}.key /etc/docker/certs.d/${DOMAIN}/
cp ca.crt /etc/docker/certs.d/${DOMAIN}/

systemctl restart docker

# 修改配置文件
sed -i "s/hostname: reg.mydomain.com/hostname: ${DOMAIN}/g" harbor.yml
sed -i "s/certificate: \/your\/certificate\/path/\/data\/cert\/${DOMAIN}.crt" harbor.yml
sed -i "s/private_key: \/your\/private\/key\/path/\/data\/cert\/${DOMAIN}.key" harbor.yml

bash prepare
bash install.sh


