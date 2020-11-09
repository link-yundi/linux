#!/bin/bash
# docker 安装并配置阿里云加速
# author: yundi.xxii <yundi.xxii@outlook.com>

# 使用yum-config-manager 命令，先装yum-utils
yum -y install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker

echo "======================================================"
echo "=                  docker installed                  ="
echo "======================================================"

# 配置阿里云加速器
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://mucj676k.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker