#!/bin/bash

set -e

find . -name '.sh' -exec chmod +x {} \;

# public params
admin_host=`egrep ^admin_host cluster-deploy/fitstor.conf|awk -F= '{print $2}'`
mon_hosts=`egrep ^mon_hosts cluster-deploy/fitstor.conf|awk -F= '{print $2}'`
ceph_hosts=`egrep ^ceph_hosts cluster-deploy/fitstor.conf|awk -F= '{print $2}'`
pga_host=`egrep ^pga_host cluster-deploy/fitstor.conf|awk -F= '{print $2}'`
iscsigw_host=`egrep ^iscsigw_host cluster-deploy/fitstor.conf|awk -F= '{print $2}'`

# os-config
sh os-config/fw_config.sh 
read -p "hostname: " hostName
sh os-config/hostname_config.sh -n $hostName 
read -p "public ip[$mon_hosts]: " publicIp
read -p "cluster ip[]: " clusterIp
sh os-config/network_config.sh -p $publicIp -c $clusterIp 


# pga-install
read -p "role [server or node]: " role
sh component-install/pga-install/pga_install.sh -r $role

# health-check
sh health-check/pga-check.sh -r $role


