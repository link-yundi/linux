#!/bin/bash
# 关闭密码登录
# author 


sed -i 's/PasswordAuthentication\ yes/\PasswordAuthentication\ no/g' /etc/ssh/sshd_config 
service sshd restart
