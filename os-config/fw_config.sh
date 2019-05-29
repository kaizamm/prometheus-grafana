#!/bin/bash

#disable selinx
setenforce 0
sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config

#config firewalld 
systemctl start firewalld
sleep 3
#iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -p all  -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type any -j ACCEPT
iptables -A INPUT -p tcp --dprot 22 -j ACCEPT 
iptables -A INPUT -p tcp --dprot 3000 -j ACCEPT 
iptables -A INPUT -p tcp --dprot 9100 -j ACCEPT 
iptables -A INPUT -p tcp --dprot 9328 -j ACCEPT 
iptables -A INPUT -p tcp --dprot 9090 -j ACCEPT 
iptables -A INPUT  -m multiport -p tcp --dports 6789:7300 -j ACCEPT
iptables -I INPUT -d 224.0.0.0/8 -j ACCEPT
iptables -A INPUT -p 112  -j ACCEPT
iptables-save
systemctl stop firewalld

