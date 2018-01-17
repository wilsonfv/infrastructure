#!/usr/bin/env bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PROJ_BASE=$BASEDIR
export PROJ_PACKAGE=$BASEDIR/package
export PROJ_PUPPET=$BASEDIR/puppet
export PROJ_SCRIPT=$BASEDIR/script
export PROJ_SERVER=$BASEDIR/server


echo 'Project base location: ' $PROJ_BASE


if [ -e ~/.ssh/id_rsa.pub ]; then
    export PROJ_PUBLICKEY=`cat ~/.ssh/id_rsa.pub`
else
    echo 'You must define your ssh public key on your host machine ~/.ssh/id_rsa.pub'
    exit 1
fi