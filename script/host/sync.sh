#!/usr/bin/env bash

hostname=$1

if [ $# == 1 ]; then
    port=22
else
    port=$2
fi


echo "upload puppet code"
ssh -q root@$hostname -p $port 'rm -rf /etc/puppetlabs/code/*'
scp -q -P $port -r  $PROJ_PUPPET/* root@$hostname:/etc/puppetlabs/code


ssh -q root@$hostname -p $port 'if [ ! -e /opt/imok/log ]; then mkdir -p /opt/imok/log; fi; chmod 755 /opt/imok/log;'
puppetApplyCmd='puppet apply -l /opt/imok/log/puppet_apply.log /etc/puppetlabs/code/environments/production/manifests/*'
echo $puppetApplyCmd
ssh -q root@$hostname -p $port $puppetApplyCmd
ssh -q root@$hostname -p $port 'chmod 755 -R /opt/imok/log/*;'