#!/bin/bash

chown -R root.root ./*
chmod -R 755 ./*

find . -name '.*conf' -exec sed 's/\r//g' {} \;

mon_hosts=`egrep ^mon_hosts os-config/fitstor.conf|awk -F= '{print $2}'`

# pga-install
monIpSub=`echo $mon_hosts|awk -F, '{print $1}'`
monIpSub2=`echo ${monIpSub%.*}`
server1=$monIpSub
server2=`echo $mon_hosts|awk -F, '{print $2}'`
echo "server1:$server1;server2:$server2"
myIp=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' |awk -F/ '{print $1}'|grep $monIpSub2`
[[ ! $myIp ]] &&  "*****error*****get host ip fail!" && exit 1

# modify rsyslog.conf
#install server or node
role=""
if [[ "$myIp"x = "$server1"x ]] || [[ "$myIp"x = "$server2"x ]] ;then
  role="server"
else
  role="node"
fi

sh component-install/pga-install/pga_install.sh -r $role
sh component-install/pga-install/pga_config.sh -m $mon_hosts -r $role

echo "role:$role"
# health-check
sleep 2
sh health-check/pga-check.sh -r $role
