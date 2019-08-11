#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- bsdtar
#	- sync
# Arguments:
#	1)	Path to Arch install image .tar.gz file.
# Preparation:
# Running Instructions
#	- Execute script in a directory with a 'build' directory with
#		'root' and 'boot' subdirectories with no content, that can be
#		mounted to. Provide one argument: Arch install image.
########################################################################

if [ $# != 1 ]
then
	echo "[ERR] Invalid arguments given. No Arch install image."
	exit 1;
fi

echo "[INFO] Uncompressing Arch install image."
bsdtar -xpf $1 -C build/root
sleep 2 # Give disk a few seconds to catch up
sync
sleep 5 # Give disk a few seconds to catch up
echo "[INFO] Moving /boot directory of Arch install to boot partition."
mv build/root/boot/* build/boot