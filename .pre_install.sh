#!/bin/bash

chown -R root.root ./*
chmod -R 755 ./*
#find . -name '.sh' -exec chmod +x {} \;

mon_hosts=`egrep ^mon_hosts os-config/fitstor.conf|awk -F= '{print $2}'`
# os-config
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
    echo "MonIp as follows:%$mon_hosts"
    read -p "public ip[]: " publicIp
    read -p "cluster ip[]: " clusterIp
    sh os-config/network_config.sh -p $publicIp -c $clusterIp 
  }
fi 
# pga-install
  monIpSub=`echo $mon_hosts|awk -F, '{print $1}'`
  monIpSub2=`echo ${monIpSub%.*}`
  server1=$monIpSub
  server2=`echo $mon_hosts|awk -F, '{print $2}'`
  echo "server1:$server1;server2:$server2"
  myIp=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' |awk -F/ '{print $1}'|grep $monIpSub2`
  [[ ! $myIp ]] &&  "*****error*****get host ip fail!" && exit 1
  
#read -p "role [server or node]: " role
role=""
if [[ "$myIp"x = "$server1"x ]] || [[ "$myIp"x = "$server2"x ]] ;then
  role="server"
  sh component-install/pga-install/pga_install.sh -r $role
  sh component-install/pga-install/pga_config.sh -m $mon_hosts
else
  role="node"
  sh component-install/pga-install/pga_install.sh -r "node"
fi
echo "role:$role"
# health-check
sh health-check/pga-check.sh -r $role


