#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- *NIX based computer
#		- sfdisk:			Partition creation
#		- bsdtar:			Image decompression
#		- tree [OPTIONAL]:	Log messages
# Preparation:
#	- Attach SD card with enough storage for the operating system.
#		- The hardware device file. (e.g. "/dev/sda")
# Running Instructions
#	- Quadruple check you have the correct device file. Don't overwrite
#		anything important!
#	- Clone the containing git repo and enter the directory, or
#		download this file and place in its own directory.
#	- Run this script:
# 		./000-Partition-and-Extract-Filesystem.py --device "/dev/sdX"
########################################################################

DEFAULT_ARCH_IMAGE_URL="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz"


################################
# Handle image override switch #
################################
DEVICE=$1
IMAGE=$2
URL=$3

if [ -z "$DEVICE" ]
then
	echo "[ERR] No SD card device specified! Must provide one as first argument."
	exit 1
fi
if [ -z "$URL" ]
then
	URL=$DEFAULT_ARCH_IMAGE_URL
fi


#####################################
# Summarize what we're going to do, #
# based on given switches, and ask  #
# for permission to continue.       #
#####################################
echo; echo;
echo "####################"
echo "# Action Breakdown #"
echo "####################"
echo "1) Create a working directory structure in: '${pwd}/build'."
echo "2) Partition the SD card, '$DEVICE', with required partition structure."
echo "3) Mount the SD card partitions in the build directory."

# If no image path, download
if [ -z "$IMAGE" ]
then
	echo "4) Download an Arch install image from '$URL' for installation."
else
	echo "4) Use existing Arch install image, '$IMAGE', for installation."
fi

echo "5) Extract Arch install image root to mounted root partition."
echo "6) Move the '/boot' contents from the root partition to the boot partition."
echo "7) Unmount and clean up build directory."

# If not root, warn
if ((${EUID:-0} || "$(id -u)"))
then # Not root user
	echo
	echo "<<<WARNING>>>: Steps 3 and 7 will require sufficient user privileges"
	echo "for 'mount' and 'umount' commands. Recommend stopping and rerunning"
	echo "with root permissions (e.g. sudo)."
fi

echo;
while true; do
	read -p "Sound good? Continue? [y/n]" yn
	case $yn in
		[Yy]* ) $CONT=true;;
		[Nn]* ) $CONT=false;;
		* ) echo "Please answer yes or no.";;
	esac
done
if [ $CONT == false ]
then
	echo "[ERR] User cancellation."
	exit 2;;
else
	echo
	echo "Awesome! Here we go!"
fi
echo; echo;


# 1) Create working directory
source 000a-Create-Working-Directory-Structure.sh

# 2) Partition SD card
source 000b-Partition-SD-Card.sh $DEVICE

# 3) Mount SD card
source 000c-Mount-SD-Partitions.sh $DEVICE

# 4) Download if neccessary
if [ -z "$IMAGE" ]
then
	source 000d-Download-Arch-Image.sh $URL
	$IMAGE="build/arch_image.tar.gz"
fi

# 5) Extract Arch install
# and 6) Move /boot
source 000e-Extract-Root-Filesystem.sh $IMAGE

# 7) Cleanup
source 000f-Cleanup-Build-Files.sh