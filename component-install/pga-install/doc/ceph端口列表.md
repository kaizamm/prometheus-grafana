# ceph及监控端口列表

```
MONITOR: 6789
MDS: 6800-7100（从6800开始）

#ceph-osd以名称来设置防火墙,osd监听的是在一个区间,对方的osd是一个随机的
OSD: 6800-7100（从6800开始，每个osd占三个端口）（经测32osd占到6872）

MGR: 6873

ceph-mgr: 9283
ceph-dashboard: 8443/https  

prometheus: 9090
node_exporter: 9100
alertmanager: 9093

grafana-server: 3000

iscsid: 3260

rbd-target-gw： 9287
rbd-target-api： 5000

```
