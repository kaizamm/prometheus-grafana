#!/bin/bash


sed -i '/#### RULES ####/a:syslogtag, contains, "prometheus" /var/log/prometheus\n& stop\n:syslogtag, contains, "alertmanager" /var/log/alertmanager\n& stop\n:syslogtag, contains, "node_exporter" /var/log/node_exporter\n& stop' /etc/rsyslog.conf

systemctl restart rsyslog
