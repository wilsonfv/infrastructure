#!/usr/bin/env bash

hostname=$1

if [ $# == 1 ]; then
    port=22
else
    port=$2
fi

masterSshKey=$PROJ_PUBLICKEY
project=/opt/imok


echo 'upload packages to server'
ssh -q root@$hostname -p $port 'if [ ! -e /package ]; then mkdir -p /package; fi; chmod 755 /package;'
scp -q -r -P $port $PROJ_PACKAGE/* root@$hostname:/package


echo 'upload scripts to server'
ssh -q root@$hostname -p $port "if [ ! -e $project/script ]; then mkdir -p $project/script; fi;"
scp -q -r -P $port $PROJ_SCRIPT/guest/* root@$hostname:$project/script
ssh -q root@$hostname -p $port "echo $masterSshKey > $project/script/master_ssh.key"
ssh -q root@$hostname -p $port "chmod 755 $project;"


echo 'add local repo config to /etc/yum.conf'
ssh -q root@$hostname -p $port "if grep -qv 'localrepo' /etc/yum.conf; then echo '[localrepo]' >> /etc/yum.conf; echo 'name=Local Repo' >> /etc/yum.conf; echo 'baseurl=file:///package/rpm/' >> /etc/yum.conf; echo 'enabled=1' >> /etc/yum.conf; echo 'failovermethod=priority' >> /etc/yum.conf; echo 'gpgcheck=0' >> /etc/yum.conf; fi;"


echo 'install yum repo'
ssh -q root@$hostname -p $port "rpm -Uvh /package/yumrepo/*noarch.rpm;"


echo 'copy yum repo to /etc/yum.repos.d/'
ssh -q root@$hostname -p $port 'cp /package/yumrepo/*.repo /etc/yum.repos.d/'


echo 'install puppet-agent'
ssh -q root@$hostname -p $port 'yum install /package/rpm/puppet-agent* -y'