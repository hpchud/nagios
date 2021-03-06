#!/bin/bash

set -e

NAGIOS_ETC=/usr/local/nagios/etc
NAGVIS_ETC=/usr/local/nagvis/etc
NAGVIS_SHARE=/usr/local/nagvis/share
CONFIG=1

# check for required vars
if [[ -z "$CONFIG_REPO" ]]; then
    echo -n >&2 "Warning: no configuration repository is set "
    echo >&2 "Did you forget to add -e CONFIG_REPO=... ?"
    CONFIG=0
fi
if [[ -z "$CONFIG_USER" ]]; then
    echo -n >&2 "Warning: the user or team name is not set "
    echo >&2 "Did you forget to add -e CONFIG_USER=... ?"
    CONFIG=0
fi
if [[ -z "$CONFIG_PASS" ]]; then
    echo -n >&2 "Warning: the password or API key is not set "
    echo >&2 "Did you forget to add -e CONFIG_PASS=... ?"
    CONFIG=0
fi

if [[ CONFIG -eq 1 ]]; then
    # reset configuration directories for nagios and nagvis
    rm -rf ${NAGIOS_ETC}
    rm -rf ${NAGVIS_ETC}/maps
    rm -rf ${NAGVIS_SHARE}/userfiles

    # clone the git repo
    echo "cloning config repository..."
    rm -rf /tmp/nagios-config
    git clone https://${CONFIG_USER}:${CONFIG_PASS}@${CONFIG_REPO} /tmp/nagios-config

    # copy nagios config
    echo "linking config to ${NAGIOS_ETC}"
    ln -s /tmp/nagios-config/nagios ${NAGIOS_ETC}

    # copy nagvis maps
    echo "linking maps to ${NAGVIS_ETC}/maps"
    ln -s /tmp/nagios-config/nagvis/maps ${NAGVIS_ETC}/maps

    # copy nagvis userfiles
    echo "linking userfiles to ${NAGVIS_SHARE}/userfiles"
    ln -s /tmp/nagios-config/nagvis/userfiles ${NAGVIS_SHARE}/userfiles

    # fix permissions
    echo "fixing permissions"
    chown nagios:nagcmd $NAGIOS_ETC -R
    chown nagios:nagcmd /tmp/nagios-config/nagios -R
    chown www-data:www-data $NAGVIS_ETC -R
    chown www-data:www-data $NAGVIS_SHARE -R
    chown www-data:www-data /tmp/nagios-config/nagvis -R
fi

echo "starting the server"
exec "$@"
