#!/bin/bash
#Discription:install prometheus and grafana-server
#Date:2019.5.21
#Author:zhangkai

set -e

dst_dir="/usr/local/prometheus"

[ -f "conf/alertmanager.yml" ] && cp --force conf/alertmanager.yml $dst_dir/alertmanager/ && systemctl restart alertmanager && echo "alertmanager conf sucess" 
[ -f "conf/prometheus.yml" ] && cp --force conf/prometheus.yml $dst_dir/prometheus/ && systemctl restart prometheus && echo "prometheus conf sucess"

