#!/bin/bash

# 配置nfs
cat << EOF > /etc/exports
/nfs *(rw,async,no_root_squash,fsid=0)
EOF

mkdir /nfs
docker run -d -v /etc/exports:/etc/exports:ro -v /nfs:/nfs -p 2049:2049 --privileged erichough/nfs-server
