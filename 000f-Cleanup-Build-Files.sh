#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- umount
# Arguments:
# Preparation:
# Running Instructions
#	- Execute script in a directory with the 'build' directory you want
#		cleaned up. Script requires user permission to mount
#		directories (e.g. sudo).
########################################################################

if [ [$EUID -ne 0] ] then # Not root user
	echo "[WARN] Script not executed with root permissions. (e.g. sudo)"
	echo "       Check output carefully for 'mount' errors and rerun"
	echo "       with elevated privileges if needed."
fi

echo "[INFO] Attempting to unmount partitions from './build/boot' and"
echo "       './build/root'."
umount build/root build/boot

echo "[INFO] Attempting to delete build directory."
rm -r build