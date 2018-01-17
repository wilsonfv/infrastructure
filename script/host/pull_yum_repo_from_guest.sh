#!/usr/bin/env bash

if [ -e ../../environment.sh ]; then
    source ../../environment.sh
elif [ -e $PROJ_BASE/environment.sh ]; then
    source $PROJ_BASE/environment.sh
fi

if [ ! -d $PROJ_PACKAGE/rpm ]; then
    mkdir -p $PROJ_PACKAGE/rpm
fi

rm -rf $PROJ_PACKAGE/rpm
scp -r -P 2222 root@127.0.0.1:/package/rpm $PROJ_PACKAGE