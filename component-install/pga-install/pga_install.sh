#!/bin/bash
#Discription:install prometheus and grafana-server
#Date:2019.5.21
#Author:zhangkai

set -e

#read -p "server or node:" node

while getopts r: option
do
case "${option}"
in
r) role=${OPTARG};;
esac
done

date_now=`date +%Y%m%d%H%M%S`
dst_dir="/usr/local/prometheus"
user="prometheus"

dirNow=$(cd "$(dirname "$0")";pwd)
egrep "^$user" /etc/passwd >& /dev/null || useradd -M prometheus
if [ "$role"x = "node"x ];then
  [ -d "/usr/local/prometheus" ] && rm -rf /usr/local/prometheus
  cp -r --force $dirNow/prometheus  $dst_dir
  cp --force $dirNow/system/node_exporter.service /usr/lib/systemd/system/
  systemctl enable node_exporter
  systemctl start node_exporter
  echo "*****[sucess]install node_exporter sucess"
  exit 0
fi

###install grafana
yum --disablerepo=\* localinstall $dirNow/grafana/rpmdir/* --skip-broken -y > /dev/null  && echo "install grafana..."

[ -d "/var/lib/grafana/plugins/vonage-status-panel" ] && rm -rf /var/lib/grafana/plugins/vonage-status-panel

unzip -o $dirNow/grafana/Vonage-Grafana_Status_panel-v1.0.9-4-g2a9b8e1.zip -d $dirNow> /dev/null
[ -d /var/lib/grafana/plugins ] || mkdir /var/lib/grafana/plugins -p
mv $dirNow/Vonage-Grafana_Status_panel-2a9b8e1 /var/lib/grafana/plugins/vonage-status-panel

[ -d "/var/lib/grafana/plugins/grafana-piechart-panel" ] && rm -rf /var/lib/grafana/plugins/grafana-piechart-panel
unzip -o $dirNow/grafana/grafana-piechart-panel-cf03cdf.zip -d $dirNow> /dev/null
mv $dirNow/grafana-piechart-panel-cf03cdf /var/lib/grafana/plugins/grafana-piechart-panel
echo "*****[sucess]install grafana-server sucess"

systemctl enable grafana-server
systemctl start grafana-server
echo "*****[sucess]service start sucess [grafana-server]"
echo "*****[info]next to view grafana website to dump json on grafana/dashboards"

# install prometheus
[ -d "/usr/local/prometheus" ] && mv $dst_dir /tmp/$date_now
cp -r --force $dirNow/prometheus  $dst_dir

[ -f "conf/alertmanager.yml" ] && cp --force $dirNow/conf/alertmanager.yml $dst_dir/alertmanager
[ -f "conf/prometheus.yml" ] && cp --force $dirNow/conf/prometheus.yml $dst_dir/prometheus

mkdir -p /var/lib/prometheus/alertmanager/data
chown -R prometheus:prometheus /var/lib/prometheus/
chown -R prometheus:prometheus /usr/local/prometheus/

cp --force $dirNow/system/* /usr/lib/systemd/system/
systemctl enable alertmanager
systemctl enable node_exporter
[ -L /etc/systemd/system/multi-user.target.wants/prometheus.service ] && rm -f /etc/systemd/system/multi-user.target.wants/prometheus.service
ln -s /usr/lib/systemd/system/prometheus.service /etc/systemd/system/multi-user.target.wants/
echo "*****[sucess]install alertmanager node_exporter prometheus sucess"
systemctl start alertmanager
systemctl start node_exporter
systemctl start prometheus
echo "*****[sucess]service start sucess [alertmanager node_exporter prometheus]"

# keepalived

[ -f "/etc/keepalived/keepalived.conf" ] && cp --force $dirNow/grafana/keepalived.conf /etc/keepalived/keepalived.conf
