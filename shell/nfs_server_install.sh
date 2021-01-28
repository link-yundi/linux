#!/bin/bash

# 停止并禁用防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭并禁用selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
getenforce

# 安装nfs-utils和rpcbind
yum install -y nfs-utils rpcbind

# 创建存储文件夹
mkdir /nfs
chown -R root.root /nfs

# 配置nfs
cat << EOF > /etc/exports
/nfs *(rw,async,no_root_squash,fsid=0)
EOF

# 设置开机启动并启动
systemctl restart rpcbind
systemctl enable rpcbind
systemctl enable nfs
systemctl restart nfs

# 查看是否有可用的 nfs地址
showmount -e localhost