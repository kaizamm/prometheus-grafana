#!/bin/bash

while getopts r: option
do
case "${option}"
in
r) role=${OPTARG};;
esac
done

netstat -antup|grep -w 9100|grep -i listen
if [ $? -ne 0 ];then
  echo "*****error*****prometheus node_exporter 9100 port,please systemctl start node_exporter"
fi

if [ "$role"x = "node"x ];then
  echo "*****[sucess]*****pga health"
  exit 0
fi

netstat -antup|grep -w 9090|grep -i listen || echo "*****error*****prometheus: prometheus 9090/port,please systemctl start prometheus"
netstat -antup|grep -w 3000|grep -i listen || echo "*****error*****grafana-server: grafana-server 3000/port,please systemctl start grafana-server"

function cephHealth()
{
  netstat -antup|grep -w 9283|grep -i listen || \
  echo "*****warning*****ceph-mgr:  9283/port,please ceph mgr services" 
  ceph mgr module enable prometheus& &>/dev/null
  ceph mgr module enable dashboard& &>/dev/null
}

cephHealth

echo "*****[sucess]*****pga health"
#ceph mgr services|grep prometheus
#if [ $? -ne 0 ]; then
#  ceph mgr module enable prometheus 
#  echo "*****warning***** ceph-mgr module prometheus not found,'ceph mgr module enable prometheus' excuting..."
#  sleep 1
#fi
#
#ceph mgr services|grep dashboard
#if [ $? -ne 0 ]; then
#  ceph mgr module enable dashboard
#  echo "*****warning***** ceph-mgr module dashboard not found,'ceph mgr module enable dashboard' excuting..."
#  sleep 1
#fi


  
  

