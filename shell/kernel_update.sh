#!/bin/bash
# 内核升级（ml最新版）
# author: yundi.xxii <yundi.xxii@outlook.com>
# 适用版本：centos7

set -e

# 导入elrepo源
echo "======================================="
echo "=            import elrepo            ="
echo "======================================="
rpm -import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

# 列出可用的内核相关包
echo "======================================="
echo "=         list available kernel       ="
echo "======================================="
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available

# 安装最新稳定版
echo "======================================="
echo "=       install latest ml release     ="
echo "======================================="
yum -y --enablerepo=elrepo-kernel install kernel-ml

# 设置新内核为默认启动选项
# 备份原启动文件
cp /etc/default/grub /etc/default/grub_bak-$(date +%y%m%d)
# 修改默认启动内核
sed -i 's/GRUB_DEFAULT/\# GRUB_DEFAULT/g' /etc/default/grub
sed -i '1i GRUB_DEFAULT=0' /etc/default/grub
# 生成 grub 配置文件
grub2-mkconfig -o /boot/grub2/grub.cfg

# 重启
# reboot

# 查看当前内核
# uname -r

# 查看所有已安装内核
# rpm -qa | grep -i kernel


# 删除旧内核
# yum remove -y $( rpm -qa | grep -i kernel | grep -v ml )

# 再次查看所有已安装内核
# rpm -qa | grep -i kernel

