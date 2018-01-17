#!/usr/bin/env bash

if [ -e ../../environment.sh ]; then
    source ../../environment.sh
elif [ -e $PROJ_BASE/environment.sh ]; then
    source $PROJ_BASE/environment.sh
fi

puppet parser validate $PROJ_PUPPET/environments/production/manifests/*
puppet parser validate $PROJ_PUPPET/environments/production/modules/*
