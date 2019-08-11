#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- mount
# Arguments:
# 	1)	The device file of the partitioned SD card.
# Preparation:
# Running Instructions
#	- Execute script in a directory with a 'build' directory with
#		'root' and 'boot' subdirectories with no content, that can be
#		mounted to. Provide one argument: the partitioned SD card
#		device file. Script requires user permission to mount
#		directories (e.g. sudo).
########################################################################

if [ [$EUID -ne 0] ] then # Not root user
	echo "[WARN] Script not executed with root permissions. (e.g. sudo)"
	echo "       Check output carefully for 'mount' errors and rerun "
	echo "       with elevated privileges if needed."
fi

$BOOT_PART = $1+"1"
$ROOT_PART = $1+"2"

echo "[INFO] Mounting root partition of SD card, '$ROOT_PART', to './build/root'."
mount $ROOT_PART build/root
echo "[INFO] Mounting boot partition of SD card, '$BOOT_PART', to './build/boot'."
mount $BOOT_PART build/boot