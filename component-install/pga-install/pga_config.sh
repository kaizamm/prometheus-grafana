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

if [[ ! "$monIp" ]];then
  dst_dir="/usr/local/prometheus"
  [ -f "conf/alertmanager.yml" ] && cp --force conf/alertmanager.yml $dst_dir/alertmanager/ && systemctl restart alertmanager && echo "alertmanager conf sucess" 
  [ -f "conf/prometheus.yml" ] && cp --force conf/prometheus.yml $dst_dir/prometheus/ && systemctl restart prometheus && echo "prometheus conf sucess"
else
  echo "now $monIp"
  monIpSub=`echo $monIp|awk -F, '{print $1}'`
  monIpSub2=`echo ${monIpSub%.*}`
  myIp=`ip addr | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' |awk -F/ '{print $1}'|grep $monIpSub2`
  dirNow=$(cd "$(dirname "$0")";pwd)
  [[ ! $myIp ]] &&  "*****error*****myIp get fail!"
  python $dirNow/pga_config.py $monIp $myIp
fi
