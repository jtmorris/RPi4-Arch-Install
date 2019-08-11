#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- wget
# Arguments:
#	1)	URL to a .tar.gz file of the desired Arch image.
#		Example: "http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz"
# Preparation:
# Running Instructions
#	- Execute script in a directory with a 'build' directory with
#		'root' and 'boot' subdirectories with no content, that can be
#		mounted to. Provide one argument: URL of download
########################################################################

if [ $# != 1 ] then
	echo "[ERR] Invalid arguments given. No download URL."
	exit 1;
fi

wget $1 -O "build/arch_image.tar.gz"