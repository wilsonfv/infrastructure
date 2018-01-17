#!/usr/bin/env bash

if [ -e ./environment.sh ]; then
    source ./environment.sh
else
    echo "./environment.sh does not exist"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "You need to enter a server name"
    exit 1
fi

serverName=$1
puppetYaml="$PROJ_SERVER/common.yaml.$serverName"
serverConfig="$PROJ_SERVER/config.$serverName"

if [ ! -f $puppetYaml ]; then
    echo "$puppetYaml not found"
    exit 1
fi

if [ ! -f $serverConfig ]; then
    echo "$serverConfig not found"
    exit 1
fi

serverIp=`cat $serverConfig | cut -d',' -f1`
serverSshPort=`cat $serverConfig | cut -d',' -f2`

cp $puppetYaml $PROJ_PUPPET/environments/production/data/common.yaml

$PROJ_SCRIPT/host/sync.sh $serverIp $serverSshPort