#!/bin/bash
systemctl stop alertmanager
systemctl stop node_exporter
systemctl stop prometheus
systemctl stop grafana-server
rm -rf /var/lib/prometheus
rm -rf /usr/lib/systemd/system/alertmanager.service
rm -rf /usr/lib/systemd/system/node_exporter.service
rm -rf /usr/lib/systemd/system/prometheus.service
yum remove grafana -y
yum remove keepalived -y
userdel prometheus 
systemctl daemon-reload
sleep 1
echo "uninstall [alertmanager node_exporter prometheus sucess grafana]"
