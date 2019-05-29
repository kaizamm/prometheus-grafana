#!/bin/bash

#disable selinx
setenforce 0
sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

#config firewalld 
systemctl start firewalld
sleep 3
#iptables -F

firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --add-port=9090/tcp --permanent
firewall-cmd --add-port=9093/tcp --permanent
firewall-cmd --add-port=9100/tcp --permanent
firewall-cmd --add-port=6789-7300/tcp --permanent

systemctl stop firewalld
