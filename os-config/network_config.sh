#!/bin/bash

while getopts p:c: option
do
case "${option}"
in
p) publicIp=${OPTARG};;
c) clusterIp=${OPTARG};;
esac
done

[[ ! $publicIp ]] || [[ ! $clusterIp ]] && echo "*****[error]*****Usage:./hostname_config.sh -p publicIp -c clusterIp"

interface=`ls /etc/sysconfig/network-scripts/|egrep ^ifcfg-e` || echo "*****[error]*****Not find interface"

networkDir='/etc/sysconfig/network-scripts'
echo "network interface as follows:"
echo "$interface"
read -p "[public interface]:"  publicInterface
read -p "[cluster interface]:"  clusterInterface


function publicConfig()
{
  #public uuid && device
  publicUuid=`egrep "^UUID" $networkDir/$publicInterface | awk -F= '{print $2}'`
  publicDevice=`egrep "^DEVICE" $networkDir/$publicInterface|awk -F= '{print $2}'`
  
  publicSubnetType="PREFIX"                                      
  read -p "[public subnet(eg:24)]:"  publicSubnet                 
  if [[ ! $publicSubnet ]]; then
    publicSubnet="24" 
  fi
  publicGatewayPre=`echo ${publicIp%.*}.254`
  read -p "[public gateway($publicGatewayPre)]:"  publicGateway
  [[ ! $publicGatewayPre ]] || publicGateway=$publicGatewayPre

  [[ ! $publicUuid ]] || [[ ! $publicDevice ]]  && echo "*****[error]*****Uid or device name get none"
  echo "*****[info]*****publicInterface:$publicInterface publicIp:$publicIp $publicSubnetType:$publicSubnet publicGateway:$publicGateway"
  read -p "confirm<Enter> cancel<ctrl+c>:"
  mv $networkDir/$publicInterface $networkDir/bak_$publicInterface  && \
  dirNow=$(cd "$(dirname "$0")";pwd)
  cp $dirNow/template/ifcfg-network $networkDir/$publicInterface || echo "*****[error]*****mv $publicInterface error"
  sleep 1
  sed -i -e  "s/^IPADDR=.*/IPADDR=$publicIp/g" -e "s/^$publicSubnetType=.*/$publicSubnetType=$publicSubnet/g" -e "s/^GATEWAY=.*/GATEWAY=$publicGateway/g" -e "s/^UUID=.*/UUID=$publicUuid/g" -e "s/^NAME=.*/NAME=$publicDevice/g" -e "s/^DEVICE=.*/DEVICE=$publicDevice/g"  $networkDir/$publicInterface
  
}

function clusterConfig()
{
  #cluster uuid && device
  clusterUuid=`egrep "^UUID" $networkDir/$clusterInterface | awk -F= '{print $2}'`
  clusterDevice=`egrep "^DEVICE" $networkDir/$clusterInterface | awk -F= '{print $2}'`
  clusterSubnetType="PREFIX"                                      
  read -p "[cluster subnet(24)]:"  clusterSubnet              
  if [[ ! $clusterSubnet ]];then
    clusterSubnet="24"
  fi
  clusterGatewayPre=`echo ${clusterIp%.*}.254`
  read -p "[cluster gateway($clusterGatewayPre)]:"  clusterGateway
  [[ ! $clusterGatewayPre ]] || clusterGateway=$clusterGatewayPre
  
  [[ ! $clusterUuid ]] || [[ ! $clusterDevice ]] && echo "*****[error]*****Uid or device name get none"
  echo "*****[info]*****clusterInterface:$clusterInterface clusterIp:$clusterIp $clusterSubnetType:$clusterSubnet  clusterGateway:$clusterGateway"

  read -p "confirm<Enter> cancel<ctrl+c>:"
  mv $networkDir/$clusterInterface $networkDir/bak_$clusterInterface  && \
  dirNow=$(cd "$(dirname "$0")";pwd)
  cp $dirNow/template/ifcfg-network $networkDir/$clusterInterface || echo "*****[error]*****mv $clusterInterface error"
  sed -i -e  "s/^IPADDR=.*/IPADDR=$clusterIp/g" -e "s/^$clusterSubnetType=.*/$clusterSubnetType=$clusterSubnet/g" -e "s/GATEWAY=.*/GATEWAY=$clusterGateway/g" -e "s/^UUID=.*/UUID=$clusterUuid/g" -e "s/^NAME=.*/NAME=$clusterDevice/g" -e "s/^DEVICE=.*/DEVICE=$clusterDevice/g"  $networkDir/$clusterInterface

}

publicConfig

if [ "$publicInterface"x = "$clusterInterface"x ];then
  echo "[*****warning*****public interace = cluster interface, just config public interace only"
  echo "*****[sucess]*****modify network,please confirm $networkDir/$publicInterface ,and systemctl restart network"
  exit 0 
fi

clusterConfig


echo "*****[sucess]*****modify network,please confirm $networkDir/$publicInterface and $networkDir/$clusterInterface ,and systemctl restart network"

read -p "please CTRL + C to quit...then restart network"
