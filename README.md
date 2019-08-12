# RPi4-Arch-Install
This collection of scripts automates the Arch setup procedure for a Raspberry Pi 4, as detailed here: https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4.

On a Linux machine, clone this repo, cd into its directory, insert a microSD card you want Arch Linux for Raspberry Pi extracted on to. Then run `./000-Partition-and-Extract-Filesystem.sh` as a user with permission to mount devices, with the device file of the microSD card as an argument. 

Optional 2nd argument is a path to the Arch compressed tar ball you want extracted. If omitted, the following will be automatically downloaded: http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz. This is useful if you want to extract the same image to multiple microSD cards. Simply download the compressed tar ball somewhere, and feed its location to the script.

Optional 3rd argument is an alternate automatic download location. Pass an empty string as the 2nd argument, and the alternate download URL if you want to overload the automatic download location detailed above.

## Examples:
**Simple:**
```bash
sudo ./000-Partition-and-Extract-Filesystem.sh /dev/sda
```

**With previously downloaded tar ball:**
```bash
sudo ./000-Partition-and-Extract-Filesystem.sh /dev/sda ~/Downloads/ArchLinuxARM-rpi-2-latest.tar.gz
```

**With overloaded tar ball download location:**
```bash
sudo ./000-Partition-and-Extract-Filesystem.sh /dev/sda "" http://myawesomearch.fu/maafu_v01000110_01010101.tar.gz
```
