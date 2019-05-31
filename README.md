#
# 时  间： 2019-05-28
#
#
0> 安装前配置：
	修改配置文件
	os-config/fitstor.conf
	admin_host是部署主节点；
	mon_hosts是monitor的安装节点；
	ceph_hosts是存储安装节点；
	pga_host是pga的安装节点；
	iscsigw_host是iscsi网关的安装节点；
	ceph_user暂时留空；
	ceph_password暂时留空；
	ntp_server是ntp的服务节点
	public_network是公共网段
	cluster_network是集群网段
	ceph_devices是用来部署osd的配置信息，例如：/dev/sdb:ceph1 表示在ceph1节点上/dev/sdb作为一个osd;依次类推

0.1> 修改配置文件
	os-config/hosts
	该配置文件用于配置ssh无密登录；参考/etc/hosts
1> 软件安装：
	将本压缩包解压到/root 目录下，解压后进入目录，执行以下命令安装ceph:
	sh ceph_install.sh
	安装过程包括配置主机名（可以回车忽略）、配置本机网络（可以回车忽略）、配置防火墙、配置ntp服务、配置ssh无秘登录（需要输入远端的登录密码）；
	配置ceph软件源，然后安装ceph相关的软件包。
	
2> 集群配置
	配置前，先拷贝CentOS-7-x86_64-Everything-1810.iso到admin_host节点的/root下；
	然后运行脚本
	sh ceph_deploy.sh