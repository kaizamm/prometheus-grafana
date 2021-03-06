#!/bin/python
#Date:2019.5.21
#Author:zhangkai

import yaml,os,sys

monIp,myIp=sys.argv[1:]
ip_tmp = monIp.split(",")
ceph_targ=map(lambda x:x+":9283",ip_tmp)
node_targ=map(lambda x:x+":9100",ip_tmp)

nowDir=os.path.abspath(os.path.dirname(__file__))
dstPath=os.path.join(nowDir,'conf/prometheus.yml')

with open(dstPath,'r+') as f:
  data = yaml.load(f)

data["alerting"]["alertmanagers"][0]["static_configs"][0]["targets"]=[myIp+":9093"]
data["scrape_configs"][0]["static_configs"][0]["targets"]=[myIp+":9090"]
data["scrape_configs"][1]["static_configs"][0]["targets"]=ceph_targ
data["scrape_configs"][2]["static_configs"][0]["targets"]=node_targ

with open(dstPath,'w+') as f:
  yaml.dump(data,f)

