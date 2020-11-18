#!/bin/bash
# open swap
# author: yundi.xxii@outlook.com

# before 
cat /proc/swaps

# create swap, this may take a few seconds
dd if=/dev/zero of=/swap bs=512 count=8388616

mkswap /swap

cat /proc/sys/vm/swappiness

sed -i "s/vm.swappiness = 0/vm.swappiness = 60/g" /etc/sysctl.conf
sysctl -p

chmod 600 /swap
swapon /swap
echo "/swap swap swap defaults 0 0" >> /etc/fstab

# check
cat /proc/swaps
