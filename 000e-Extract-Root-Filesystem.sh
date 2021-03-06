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
sync
echo "[INFO] Moving /boot directory of Arch install to boot partition."
# Need to copy, not move, in case there's something at the destination.
cp -rf build/root/boot/* build/boot
rm -rf build/root/boot