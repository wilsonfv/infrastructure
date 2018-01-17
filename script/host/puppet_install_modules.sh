#!/usr/bin/env bash

if [ -e ../../environment.sh ]; then
    source ../../environment.sh
elif [ -e $PROJ_BASE/environment.sh ]; then
    source $PROJ_BASE/environment.sh
fi

puppet module install puppetlabs-accounts --target-dir $PROJ_PUPPET/environments/production/modules/
puppet module install puppetlabs-stdlib --target-dir $PROJ_PUPPET/environments/production/modules/
