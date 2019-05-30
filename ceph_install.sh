#!/bin/bash

find . -name '.sh' -exec chmod +x {} \;

# public params
admin_host=`egrep ^admin_host os-config/fitstor.conf|awk -F= '{print $2}'`
mon_hosts=`egrep ^mon_hosts os-config/fitstor.conf|awk -F= '{print $2}'`
ceph_hosts=`egrep ^ceph_hosts os-config/fitstor.conf|awk -F= '{print $2}'`
pga_host=`egrep ^pga_host os-config/fitstor.conf|awk -F= '{print $2}'`
iscsigw_host=`egrep ^iscsigw_host os-config/fitstor.conf|awk -F= '{print $2}'`

ip a | grep $admin_host
if [ $? -eq 0 ]
then 
	server=true
else
	server=false
fi
echo "The server is $server"

# 1.os-config
sh os-config/fw_config.sh 

read -p "config hostname?[yes] or [no]<default> " hostNameFlag

if [[ "$hostNameFlag"x = "yes"x ]];then
{
  read -p "hostname:" hostName
  echo "hostname:$hostName"
  [[ ! $hostName ]] || sh os-config/hostname_config.sh -n $hostName
}
fi

read -p "config network?:[yes] or [no]<default>" net
if [[ "$net"x = "yes"x  ]];then
  {
    read -p "public ip[$mon_hosts]: " publicIp
    read -p "cluster ip[]: " clusterIp
    sh os-config/network_config.sh -p $publicIp -c $clusterIp
  }
fi

# 1.1配置ceph源
cd /root/ceph-install/os-config/
sh local_source.sh
# 1.2 ntp安装
cd /root/ceph-install/os-config/
sh ntp_config.sh
# 1.3 ssh配置
cd /root/ceph-install/os-config/
sh ssh_config.sh
echo "############finish set ssh###############"


# 1.4 配置局域网源
FILE_NAME=/root/ceph-install/os-config/fitstor.conf
ADMIN=$(cat $FILE_NAME | grep admin_host | awk -F '=' '{print $2}')
echo "$ADMIN"



if $server
then
	cd /root/ceph-install/
        sh make-source.sh
fi

#2.ceph相关软件安装
#2.1 ceph 软件安装
echo "##################start to install ceph#####################"
cd /root/ceph-install/component-install/ceph_pkgs-13.05/
#sh ceph_deploy_install.sh

# pga-install
# 此处判断是否是server
cd /root/ceph-install/component-install/pga-install/
if $server
then	
	echo "pga_install server"
	sh pga_install.sh -r server
else
	echo "pga_install node"
	sh pga_install.sh -r node
fi
