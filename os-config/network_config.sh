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

#public uuid && device
publicUuid=`egrep "^UUID" $networkDir/$publicInterface | awk -F= '{print $2}'`
publicDevice=`egrep "^DEVICE" $networkDir/$publicInterface|awk -F= '{print $2}'`
#cluster uuid && device
clusterUuid=`egrep "^UUID" $networkDir/$clusterInterface | awk -F= '{print $2}'`
clusterDevice=`echo $clusterInterface|awk -F- '{print $2}'`
[[ ! $publicUuid ]] || [[ ! $publicDevice ]] || [[ ! $clusterUuid ]] || [[ ! $clusterDevice ]] && echo "*****[error]*****Uid or device name get none"

publicSubnetType="PREFIX"                                      
read -p "[public subnet(eg:24)]:"  publicSubnet                 
read -p "[public gateway]:"  publicGateway

clusterSubnetType="PREFIX"                                      
read -p "[cluster subnet(eg:24)]:"  clusterSubnet              
read -p "[cluster gateway]:"  clusterGateway

echo "*****[info]*****publicIp:$publicIp $publicSubnetType:$publicSubnet publicGateway:$publicGateway"
echo "*****[info]*****clusterIp:$clusterIp $clusterSubnetType:$clusterSubnet  clusterGateway:$clusterGateway"

mv $networkDir/$publicInterface $networkDir/bak_$publicInterface  && \
cp template/ifcfg-network $networkDir/$publicInterface || echo "*****[error]*****mv $publicInterface error"

sed -i -e  "s/^IPADDR=.*/IPADDR=$publicIp/g" -e "s/^$publicSubnetType=.*/$publicSubnetType=$publicSubnet/g" -e "s/^GATEWAY=.*/GATEWAY=$publicGateway/g" -e "s/^UUID=.*/UUID=$publicUuid/g" -e "s/^NAME=.*/NAME=$publicDevice/g" -e "s/^DEVICE=.*/DEVICE=$publicDevice/g"  $networkDir/$publicInterface

mv $networkDir/$clusterInterface $networkDir/bak_$clusterInterface  && \
cp template/ifcfg-network $networkDir/$clusterInterface || echo "*****[error]*****mv $clusterInterface error"
sed -i -e  "s/^IPADDR=.*/IPADDR=$clusterIp/g" -e "s/^$clusterSubnetType=.*/$clusterSubnetType=$clusterSubnet/g" -e "s/GATEWAY=.*/GATEWAY=$clusterGateway/g" -e "s/^UUID=.*/UUID=$clusterUuid/g" -e "s/^NAME=.*/NAME=$clusterDevice/g" -e "s/^DEVICE=.*/DEVICE=$clusterDevice/g"  $networkDir/$clusterInterface

echo "*****[sucess]*****modify network,please confirm $networkDir/$clusterInterface and $networkDir/$publicInterface,and systemctl restart network"
