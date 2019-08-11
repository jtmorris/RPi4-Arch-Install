#!/usr/bin/env python3

########################################################################
# Author	:	John Morris
# Website	:	https://github.com/jtmorris
# Source	:	https://github.com/jtmorris/RPi4-Arch-Install
# Requires:
#	- *NIX based computer
#		- Python 3
#		- sfdisk
#		- bsdtar
# Preparation:
#	- Attach SD card with enough storage for the operating system.
#		- The hardware device file. (e.g. "/dev/sda")
# Running Instructions
#	- Quadruple check you have the correct device file. Don't overwrite
#		anything important!
#	- Clone the containing git repo and enter the directory, or
#		download this file and place in its own directory.
#	- Run this script:
# 		python3 000-Partition-and-Extract-Filesystem.py --device "/dev/sdX"
########################################################################

from helper_tools import sh_command_wrapper as shcw
from helper_tools import get_output_from_sh_command as goshcw
from helper_tools import confirmation_query
import argparse
import sys
import urllib.request
import os

def main():
	# Command Line Arguments
	args = define_args()
	dev = args.get("device", None)
	url = args.get("url", None)
	img = args.get("image", None)

	###################
	# Format the card #
	###################
	print("[INFO] Formatting card.")

	#### Confirm with the user that all data will be wiped.
	print("\n\n\n")
	confirmation = confirmation_query("DEVICE '" + dev +
	"' WILL BE ERASED COMPLETELY! Continue?", "no")
	print("\n\n\n")
	if not confirmation:
		print("[ERR] User cancellation: Rejected formatting device.")
		sys.exit(1)

	#### Wipe the partition table and import partitions
	print("[INFO] Wiping partition and creating partitions.")
	shcw("sudo sfdisk " + dev + " < partition_structure.sfdisk")


	###########################################
	# Make a build space and mount partitions #
	###########################################
	print("[INFO] Making build directories.")
	shcw("mkdir build")
	shcw("mkdir build/root")
	shcw("mkdir build/boot")
	goshcw(shcw("tree build"))
	os.chdir("build")
	print('[INFO] Changing to build working directory: ' + goshcw(shcw("pwd")))

	#### Mount the partitions to working directories
	print("[INFO] Mounting the partitions.")
	goshcw(shcw("sudo mount " + dev + "1 boot"))
	goshcw(shcw("sudo mount " + dev + "2 root"))

	######################
	# Download the image #
	######################
	if not img:
		print("[INFO] Downloading image. This may take a while.")
		urllib.request.urlretrieve(url, "arch_image.tar.gz")
		img = "arch_image.tar.gz"
		print("[INFO] Download completed. Image stored at './build/arch_image.tar.gz.'")
	else:
		# We may have been given a relative image path. However, we have
		# changed to the build directory, which breaks the relative path.
		# So... let's make it absolute.
		os.chdir("../")
		img = os.path.abspath(img)
		print("[INFO] Path to image provided at: " + img)
		os.chdir("build")

	#####################
	# Extract the image #
	#####################
	print("[INFO] Extracting image to mounted root partition.")
	shcw("bsdtar -xpf " + img + " -C root")
	shcw("sync")
	print("[INFO] Moving '/boot' directory to boot partition.")
	shcw("mv root/boot/* boot")

	############
	# Clean up #
	############
	print("[INFO] Unmounting partitions.")
	shcw("sudo umount root boot")
	print ("[INFO] Cleaning up.")
	os.chdir("../")
	shcw("rm -r build")

	print("\n\n\n")
	print("[INFO] SD Card ready. Arch installed.")
	print("\t Default user: 'alarm'\t\t Password: 'alarm'")
	print("\t Root user: 'root'\t\t Password: 'root'")
	print("\t Run the following commands upon first sign-in:")
	print("\t\t\t 'pacman-key --init'")
	print("\t\t\t 'pacman-key --populate archlinuxarm'")
	print("[INFO] Don't forget to configure your system!")
	print("\t\t\t https://wiki.archlinux.org/index.php/Installation_guide#Configure_the_system")


def define_args():
	ap = argparse.ArgumentParser()
	#### Location of download of Arch install image.
	#### Example: "http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz"
	ap.add_argument("-u", "--url",
		help="Download location of the Arch image.",
		default="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz")

	#### The device to format and install to.
	#### Example: "/dev/sda"
	ap.add_argument("-d", "--device",
		help="Disk to install to. Example: /dev/sda")

	args = vars(ap.parse_args())
	dev = args.get("device", None)
	url = args.get("image", None)

	#### Override the image download and specify one already downloaded
	#### Example: "~/RpPi4-Arch-Install/arch_image.tar.gz"
	ap.add_argument("i", "--image",
		help="Path to an already downloaded Arch image.",
		default=None)

	if not dev:
		print("[ERR] No device selected. One must be provided via the " +
			" '--device' argument.")
		sys.exit(1)

	if not url:
		print("No Arch image download location provided. One must be provided." +
			" Try the '--image' argument.")
		sys.exit(1)

	return args




if __name__ == "__main__":
	main()