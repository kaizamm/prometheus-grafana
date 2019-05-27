#!/bin/bash

while getopts r: option
do
case "${option}"
in
r) hostName=${OPTARG};;
esac
done

netstat -antup|grep 9100
if [ $? -ne 0 ] then
  echo "*****error*****prometheus node_exporter 9100/port,please systemctl start node_exporter"

if [ "$role"x = "node" ] then
  exit 0
fi

netstat -antup|grep 9090 || echo "*****error*****prometheus: prometheus 9090/port,please systemctl start prometheus"

ceph mgr services|grep prometheus
if [ $? -ne 0 ] then
  ceph mgr module enable prometheus 
  echo "*****warning***** ceph-mgr module prometheus not found,'ceph mgr module enable prometheus' excuting..."
  sleep 9
fi

ceph mgr services|grep dashboard
if [ $? -ne 0 ] then
  ceph mgr module enable dashboard
  echo "*****warning***** ceph-mgr module dashboard not found,'ceph mgr module enable dashboard' excuting..."
  sleep 9
fi

netstat -antup|grep 9328 || echo "*****error*****ceph-mgr: 9328/port,please do 'ceph mgr module enable prometheus'"

netstat -antup|grep 3000 || echo "******error*****grafana-server:3000/port,please systemctl restart grafana-server"
  
  

