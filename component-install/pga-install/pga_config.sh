#!/bin/bash
#Discription:install prometheus and grafana-server
#Date:2019.5.21
#Author:zhangkai

#set -e

while getopts m: option
do
case "${option}"
in
m) monIp=${OPTARG};;
esac
done

function config()
{
    dst_dir="/usr/local/prometheus"
    dirNow=$(cd "$(dirname "$0")";pwd)
  [ -f "$dirNow/conf/alertmanager.yml" ] && cp --force $dirNow/conf/alertmanager.yml $dst_dir/alertmanager/ && systemctl restart alertmanager && echo "alertmanager conf sucess"
  [ -f "$dirNow/conf/prometheus.yml" ] && cp --force $dirNow/conf/prometheus.yml $dst_dir/prometheus/ && systemctl restart prometheus && echo "prometheus conf sucess"
}

function modify_config()
{
  monIpSub=`echo $monIp|awk -F, '{print $1}'`
  monIpSub2=`echo ${monIpSub%.*}`
  myIp=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' |awk -F/ '{print $1}'|grep $monIpSub2`
  dirNow=$(cd "$(dirname "$0")";pwd)
  [[ ! $myIp ]] &&  "*****error*****Ip get fail!" && exit 1
  python $dirNow/pga_config.py $monIp $myIp
}

if [[ ! "$monIp" ]];then
  config
else
  modify_config
  config
fi
