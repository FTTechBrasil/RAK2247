#! /bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

GATEWAY_FREQ="au_915_928"
GLOBAL_FOLDER=/opt/ttn-gateway/packet_forwarder/lora_pkt_fwd
NOT_SUDO="sudo -u pi"

echo "**********************************************************************"
echo "The Things Network Gateway installer for the RAK2247 mPCIe Concetrator"
echo "**********************************************************************"
echo

if [ -d "rak_common_for_gateway" ]; then
    echo "[WARNING] You already have the 'rak_common_for_gateway' cloned in this rep" 
else
    echo "[INFO] Cloning 'rak_common_for_gateway'" 
    $NOT_SUDO git clone https://github.com/RAKWireless/rak_common_for_gateway.git
    echo
fi

ETHO_IP=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d "/" -f 1)
if [ -z "$ETHO_IP" ] || [ "$ETH0_IP" == "127.0.0.1" ]; then
    echo "[WARNING] You need to be connected using ethernet (eth0)"
    echo "[INFO] If you don't know, check by running ifconfig"
    echo "[INFO] If you're not connected though the eth0, check rak official documentation."
    echo "[INFO] https://docs.rakwireless.com/Product-Categories/WisLink/RAK2247/Quickstart/#rak2247-x86-linux-pc"
fi

echo  >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "# [INFO] Lines below were added afterwards" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "cp ../set_eui.sh packet_forwarder/lora_pkt_fwd/" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "cp ../start.sh packet_forwarder/lora_pkt_fwd/" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "mkdir -p /opt/ttn-gateway/" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "cp -rf packet_forwarder /opt/ttn-gateway/" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo  >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "# [INFO] Set packet forwarder to start on boot" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "cp ../ttn-gateway.service /lib/systemd/system/" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "systemctl enable ttn-gateway.service" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo "systemctl start ttn-gateway.service" >> rak_common_for_gateway/lora/rak2247_usb/install.sh
echo  >> rak_common_for_gateway/lora/rak2247_usb/install.sh

# Replace start with improved one
cp start.sh rak_common_for_gateway/lora/start.sh
# More friendly way to check EUI
cp showeui.sh /opt/ttn-gateway/packet_forwarder/lora_pkt_fwd/ 
# install rak2247_usb
pushd rak_common_for_gateway/lora/rak2247_usb
    ./install.sh
popd

# Replace global_conf.json
cp $GLOBAL_FOLDER/global_conf/global_conf.$GATEWAY_FREQ.json $GLOBAL_FOLDER/global_conf.json
echo "**********************************************************************"

./showeuish

# sudo systemctl stop ttn-gateway.service
# service ttn-gateway status
# chmod +x *.sh