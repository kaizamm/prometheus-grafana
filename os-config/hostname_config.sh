#!/bin/bash

while getopts n: option
do
case "${option}"
in
n) hostName=${OPTARG};;
esac
done

[ ! $hostName ] && echo "*****[error]*****Usage:./hostname_config.sh -n hostname" && exit 1
echo $hostName > /etc/hostname
hostname $hostName

echo "*****[sucess]*****hostname:$hostName"
