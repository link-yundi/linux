#!/bin/bash

yum install -y nfs-utils rpcbind

host="47.56.30.57"
mountPath="/nfs"

mkdir ${mountPath}
mount -t nfs -o nolock,vers=4 ${host}:/ ${mountPath}

# 卸载挂载
# umount ${mountPath}

# 查看nfs服务端信息
# nfsstat -s
# 查看客户端信息
# nfsstat -c