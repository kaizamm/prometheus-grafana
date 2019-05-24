#!bin/bash

yum localinstall rpmdir/* -y
unzip Vonage-Grafana_Status_panel-v1.0.9-4-g2a9b8e1.zip
sleep 3
unzip grafana-piechart-panel-cf03cdf.zip 
sleep 3
mv Vonage-Grafana_Status_panel-2a9b8e1 /var/lib/grafana/plugins/vonage-status-panel
sleep 3
mv grafana-piechart-panel-cf03cdf/ /var/lib/grafana/plugins/grafana-piechart-panel
sleep 3

ls /var/lib/grafana/plugins/grafana-piechart-panel
grafana-cli plugins ls
systemctl start grafana-server
systemctl enable grafana-server
systemctl status grafana-server
