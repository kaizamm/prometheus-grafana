#!/bin/bash
#Discription:install prometheus and grafana-server
#Date:2019.5.21
#Author:zhangkai

set -e

read -p "server or node:" node

date_now=`date +%Y%m%d%H%M`
dst_dir="/usr/local/prometheus"
user="prometheus"

egrep "^$user" /etc/passwd >& /dev/null || useradd -M prometheus
if [ "$node"x = "node"x ];then
  cp --force system/node_exporter.service /usr/lib/systemd/system/
  sleep 1
  systemctl enable node_exporter
  systemctl start node_exporter
  echo "*****[sucess]install node_exporter sucess"
  exit 0
fi

[ -d "/usr/local/prometheus" ] && mv $dst_dir /tmp/$date_now 
cp -rn prometheus  $dst_dir

[ -f "conf/alertmanager.yml" ] && cp --force conf/alertmanager.yml $dst_dir/alertmanager
[ -f "conf/prometheus.yml" ] && cp --force conf/prometheus.yml $dst_dir/prometheus

mkdir -p /var/lib/prometheus/alertmanager/data
chown -R prometheus:prometheus /var/lib/prometheus/
chown -R prometheus:prometheus /usr/local/prometheus/

cp --force system/* /usr/lib/systemd/system/
systemctl enable alertmanager
systemctl enable node_exporter
[ -L /etc/systemd/system/multi-user.target.wants/prometheus.service ] && rm -f /etc/systemd/system/multi-user.target.wants/prometheus.service 
ln -s /usr/lib/systemd/system/prometheus.service /etc/systemd/system/multi-user.target.wants/
echo "*****[sucess]install alertmanager node_exporter prometheus sucess"
systemctl start alertmanager
systemctl start node_exporter
systemctl start prometheus
echo "*****[sucess]service start sucess [alertmanager node_exporter prometheus]"

###install grafana
yum localinstall grafana/rpmdir/* -y > /dev/null  && echo "install grafana..." 

[ -d "/var/lib/grafana/plugins/vonage-status-panel" ] && rm -rf /var/lib/grafana/plugins/vonage-status-panel

unzip -o grafana/Vonage-Grafana_Status_panel-v1.0.9-4-g2a9b8e1.zip > /dev/null
mv Vonage-Grafana_Status_panel-2a9b8e1 /var/lib/grafana/plugins/vonage-status-panel 

[ -d "/var/lib/grafana/plugins/grafana-piechart-panel" ] && rm -rf /var/lib/grafana/plugins/grafana-piechart-panel 
unzip -o grafana/grafana-piechart-panel-cf03cdf.zip > /dev/null
mv grafana-piechart-panel-cf03cdf /var/lib/grafana/plugins/grafana-piechart-panel
echo "*****[sucess]install grafana-server sucess"

systemctl enable grafana-server
systemctl start grafana-server 
echo "*****[sucess]service start sucess [grafana-server]"
echo "*****[info]next to view grafana website to dump json on grafana/dashboards"

