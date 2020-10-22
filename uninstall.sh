#!/bin/bash

INSTALL_DIR="/opt/ttn-gateway"
SERVICE="ttn-gateway"

echo "[TTN Gateway] Removing service and folder"
echo "All configurations will be lost" 
read -p "Do you want to continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# service obliteration
systemctl stop $SERVICE
systemctl disable $SERVICE
rm /lib/systemd/system/$SERVICE".service"
systemctl daemon-reload
systemctl reset-failed


# delete folder
rm -R $INSTALL_DIR

echo "[TTN Gateway] Finished uninstall script"