#!/bin/bash


sed -i '/#### RULES ####/asyslogtag, contains, "prometheus" /var/log/prometheus\nsyslogtag, contains, "alertmanager" /var/log/alertmanager\nsyslogtag, contains, "node_exporter" /var/log/node_exporter\nsyslogtag, contains, "prometheus" ~\nsyslogtag, contains, "alertmanager" ~\nsyslogtag, contains, "node_exporter" ~' /etc/rsyslog.conf

systemctl restart rsyslog
