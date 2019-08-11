#!/bin/bash

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- tree [OPTIONAL]:
#		Used to show structure. Will throw error if not installed, but
#		is not necessary for script's primary function.
# Arguments:
# Preparation:
# Running Instructions
#	- Execute script in a directory in which you have write permission
#		and there is no "build" directory. Recommend within the git
#		repository this file was taken from.
########################################################################

echo "[INFO] Creating build directory structure."
mkdir build build/boot build/root
echo "[INFO] Structure created."
tree build