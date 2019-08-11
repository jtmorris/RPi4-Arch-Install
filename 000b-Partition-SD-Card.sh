#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- sfdisk
# Arguments:
#	1)	Path to device file of SD card to partition.
#		Example: "/dev/sda"
# Preparation:
# Running Instructions
#	- Execute script with one argument: Device file of SD card.
########################################################################

if [ $# != 1 ]
then
	echo "[ERR] Invalid arguments given. No device file."
	exit 1;
fi

# Make absolutely sure all data is losable!
echo "[INFO] This script will format the specified device: $1"
echo; echo;
while true; do
	read -p "All files will be lost on '$1'. Are you sure? [y/n]" yn
	case $yn in
		[Yy]* )
			CONT=true;
			break
			;;
		[Nn]* )
			CONT=false;
			break
			;;
		* )
			echo "Please answer yes or no."
			;;
	esac
done
if [ $CONT == false ]
then
	echo "[ERR] User cancellation."
	exit 2;;
fi
echo; echo;


# Format that bad boy!
echo "[INFO] Formatting and partitioning '$1'."
sudo sfdisk $1 < partition_structure.sfdisk
echo "[INFO] Formatting and partitioning complete."