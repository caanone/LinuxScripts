#!/bin/bash
rpm -ivh http://repo.zabbix.com/zabbix/3.5/rhel/7/x86_64/zabbix-release-3.5-1.el7.noarch.rpm
yum install zabbix-agent -y 
firewall-cmd --zone=public --add-port=10050/tcp --permanent
firewall-cmd --reload
iptables -A INPUT -p tcp -m tcp --dport 10050 -j ACCEPT
/usr/libexec/iptables/iptables.init save
#sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"
#PSK=$(cat /etc/zabbix/zabbix_agentd.psk)
#echo "PSK key is  $PSK "
#cat ./zabbix.conf > /etc/zabbix/zabbix_agentd.conf
systemctl restart zabbix-agent
systemctl enable zabbix-agent
