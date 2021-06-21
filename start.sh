#! /bin/bash

# Reset iC880a PIN
SX1301_RESET_BCM_PIN=27
echo "$SX1301_RESET_BCM_PIN"  > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/direction
echo "0"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 0.1
echo "1"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 0.1
echo "0"   > /sys/class/gpio/gpio$SX1301_RESET_BCM_PIN/value
sleep 0.1
echo "$SX1301_RESET_BCM_PIN" > /sys/class/gpio/unexport

echo "Checking for internet connectivity..."
# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "Waiting for internet connection..."
  sleep 30
  done

grep -q 0000000000000000 global_conf.json
if [[ $? == 0 ]]
then
  GATEWAY_EUI_NIC="eth0"
  GATEWAY_EUI=$(ip link show $GATEWAY_EUI_NIC | awk '/ether/ {print $2}' | awk -F\: '{print $1$2$3"FFFE"$4$5$6}')
  GATEWAY_EUI=${GATEWAY_EUI^^}

  echo "First boot config update running"
  echo "GATEWAY EUI = [$GATEWAY_EUI]"
  echo "$GATEWAY_EUI" >euid.txt
  sed -i --follow-symlinks "s|0000000000000000|$GATEWAY_EUI|g" ./global_conf.json #replace gateway ID
  sleep 0.5
fi

echo "Starting Packet Forwarder..."
# Fire up the forwarder.
./lora_pkt_fwd
