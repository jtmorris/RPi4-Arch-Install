#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- mount
# Arguments:
#	1)	Path to device file of SD card to partition.
#		Example: "/dev/sda"
#	2)	WiFi SSID.
#	3)	WiFi password.
# Preparation:
# Running Instructions
#	- Execute script with one three arguments. The device file, WiFi
#		SSID, and WiFi password. Script must be executed by user with
#		permission to mount partitions.
#		Example: sudo ./setup-wifi.sh /dev/sdX BestWiFiSSID BestWiFiPassword
########################################################################

if [[ $# -ne 3 ]]; then
	echo "[ERR] Improper number of arguments! Must provide 3 arguments: 1) device file, 2) WiFi SSID, 3) WiFi password."
	exit 1
fi

DEVICE="$1"
WIFISSID="$2"
WIFIPASS="$3"

if ((${EUID:-0} || "$(id -u)"))
then # Not root user
	echo "[WARN] Script not executed with root permissions. (e.g. sudo)"
	echo "       Check output carefully for 'mount' errors and rerun "
	echo "       with elevated privileges if needed."
fi


if [[ ! -b "${DEVICE}" ]]; then
	echo "[ERR] Device file given (\"${DEVICE}\") is not a block device."
	exit 1
fi


# Create working directories
source ../000a-Create-Working-Directory-Structure.sh

# Mount partitions
source ../000c-Mount-SD-Partitions.sh ${DEVICE}

# Save service files to proper location
echo "[INFO] Creating WiFi service configuration file."
cat << EOF >> build/root/etc/systemd/network/wlan0.network
[Match]
Name=wlan0

[Network]
DHCP=yes
EOF

echo "[INFO] Saving WiFi authentication information."
wpa_passphrase "${WIFISSID}" "${WIFIPASS}" > build/root/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

echo "[INFO] Setting up service to start."
ln -s \
	/usr/lib/systemd/system/wpa_supplicant@.service \
	build/root/etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service

# Clean up build files
source ../000f-Cleanup-Build-Files.sh