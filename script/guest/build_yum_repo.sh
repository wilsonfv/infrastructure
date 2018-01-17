#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PACKAGE_PATH=/package/rpm

if [ ! -d $PACKAGE_PATH ]; then
    mkdir -p $PACKAGE_PATH
fi

if test `yum list installed | grep createrepo | wc -l` -eq 0; then
    yum install -y createrepo
fi

yum install -y createrepo --downloadonly --downloaddir=$PACKAGE_PATH
yum install -y php-gd --downloadonly --downloaddir=$PACKAGE_PATH
yum install -y yum-plugin-priorities --downloadonly --downloaddir=$PACKAGE_PATH

rm -rf $PACKAGE_PATH/repodata
createrepo $PACKAGE_PATH

