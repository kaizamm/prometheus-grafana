### 修改配置文件

修改`conf/prometheus.yml`：修改ceph集群IP [必选]

修改 `conf/alertmanager.yml`:配置邮箱地址 [可选]


### ceph-mgr配置

```
ceph mgr module enable dashboard
ceph mgr module enable prometheus
```

#### 原生dashboard配置


```
# mkdir mgr-dashboard && cd mgr-dashboard/
# openssl req -new -nodes -x509 -subj "/O=IT/CN=ceph-mgr-dashboard" -days 3650 -keyout dashboard.key -out dashboard.crt -extensions v3_ca
Generating a 2048 bit RSA private key
# ls
dashboard.crt  dashboard.key

$ ceph config-key set mgr/dashboard/crt -i dashboard.crt
$ ceph config-key set mgr/dashboard/key -i dashboard.key

# ceph mgr module disable dashboard
# ceph mgr module enable dashboard
```
注意，要是不要想https可以关闭
```
ceph config set mgr mgr/dashboard/ssl false
```


### 安装

1. 执行脚本

```
./install.sh

server or node:

```
2. 选择安装角色 server or node

server会安装所有的服务:**prometheus/alertmanager/node_exporter/grafana-server**

node只安装 **node_exporter**

3. 等待安装完成

```
systemctl status prometheus
systemctl status node_exporter
systemctl status alertmanager
systemctl status grafana-server
```

4. 访问grafana页面，配置dashboard

http://<IP>:3000  

首次进入用户名 admin/admin

json加载：`grafana/dashboards/`
