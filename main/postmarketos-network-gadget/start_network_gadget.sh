#!/bin/sh -e
#
# Standalone utility for setting up the postmarketOS network gadget
#

. /usr/share/initramfs/init_functions.sh

CONFIGFS=/sys/kernel/config/usb_gadget

for i in $(seq 1 30); do
	if [ -n "$(ls /sys/class/udc)" ]; then
		break
	fi
	sleep 1
done

if [ $i = 30 ]; then
	echo "UDC never appeared!"
	exit 1
fi

setup_usb_network_configfs
start_unudhcpd
