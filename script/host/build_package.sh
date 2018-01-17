#!/usr/bin/env bash

if [ -e ../../environment.sh ]; then
    source ../../environment.sh
elif [ -e $PROJ_BASE/environment.sh ]; then
    source $PROJ_BASE/environment.sh
fi

if [ ! -d $PROJ_PACKAGE/rpm ]; then
    mkdir -p $PROJ_PACKAGE/rpm
fi

if [ ! -d $PROJ_PACKAGE/wordpress ]; then
    mkdir -p $PROJ_PACKAGE/wordpress
fi

wget https://wordpress.org/wordpress-4.8.2.tar.gz -P $PROJ_PACKAGE/wordpress
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P $PROJ_PACKAGE/wordpress
wget https://downloads.wordpress.org/plugin/updraftplus.1.13.11.zip -P $PROJ_PACKAGE/wordpress

