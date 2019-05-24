#!/bin/bash

while getopts p:c: option
do
case "${option}"
in
p) publicIp=${OPTARG};;
c) clusterIp=${OPTARG};;
esac
done

[[ ! $publicIp ]] || [[ ! $clusterIp ]] && echo "*****[error]*****Usage:./hostname_config.sh -p publicIp -c clusterIp" && exit 1

interface=`ls /etc/sysconfig/network-scripts/|grep ifcfg-en` || echo "*****[error]*****Not find interface"

networkDir='/etc/sysconfig/network-scripts'
echo "network interface as follows:"
echo "$interface"
read -p "[public interface]:"  publicInterface
read -p "[cluster interface]:"  clusterInterface

publicSubnetType="NETMASK"
egrep "^PREEFIX=" $networkDir/$publicInterface                   && \
publicSubnetType="PREEFIX"                                       && \
read -p "[public subnet(eg:24)]:"  publicSubnet                  || \
read -p "[public subnet(eg:255.255.255.0)]:"  publicSubnet

read -p "[public gateway]:"  publicGateway
read -p "[public dns]:"  publicDns

clusterSubnetType="NETMASK"
egrep "^PREEFIX=" $networkDir/$clusterInterface                  && \
clusterSubnetType="PREEFIX"                                      && \
read -p "[cluster subnet(eg:24)]:"  clusterSubnet                || \
read -p "[cluster subnet(eg:255.255.255.0)]:"  clusterSubnet

read -p "[cluster gateway]:"  clusterGateway
read -p "[cluster dns]:"  clusterDns

echo "*****[info]*****publicIp:$publicIp $publicSubnetType:$publicSubnet publicGateway:$publicGateway publicDns1:$publicDns"
echo "*****[info]*****clusterIp:$clusterIp $clusterSubnetType:$clusterSubnet  clusterGateway:$clusterGateway clusterDns1:$clusterDns"
sed -i -e  "s/^IPADDR=.*/IPADDR=$publicIp/g" -e "s/^$publicSubnetType=.*/$publicSubnetType=$publicSubnet/g" -e "s/^GATEWAY=.*/GATEWAY=$publicGateway/g" -e "s/^DNS1=.*/DNS1=$publicDns/g" $networkDir/$publicInterface

sed -i -e  "s/^IPADDR=.*/IPADDR=$clusterIp/g" -e "s/^$clusterSubnetType=.*/$clusterSubnetType=$clusterSubnet/g" -e "s/GATEWAY=.*/GATEWAY=$clusterGateway/g" -e "s/^DNS1=.*/DNS1=$clusterDns/g" $networkDir/$clusterInterface

echo "*****[sucess]*****modify network,please confirm $networkDir/$clusterInterface and $networkDir/$publicInterface,and systemctl restart network"
