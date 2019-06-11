#!/bin/bash

chown -R root.root ./*
chmod -R 755 ./*

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
    read -p "please CTRL + C to quit...then restart network"
  }
fi
