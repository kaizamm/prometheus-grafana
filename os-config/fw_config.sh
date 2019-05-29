#!/bin/bash

#disable selinx
setenforce 0
sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

#config firewalld 
systemctl start firewalld
sleep 3
#iptables -F

firewall-cmd --add-port=22/tcp --permanent >/dev/null
firewall-cmd --add-port=3000/tcp --permanent >/dev/null
firewall-cmd --add-port=9090/tcp --permanent >/dev/null
firewall-cmd --add-port=9093/tcp --permanent >/dev/null
firewall-cmd --add-port=9100/tcp --permanent >/dev/null
firewall-cmd --add-port=6789-7300/tcp --permanent >/dev/null

systemctl stop firewalld
echo "firewalld stopped"
