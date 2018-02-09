# Raspberry Pi hacks

This repository contains proof of concept code for performing
first-boot initialisation on a Raspbian system without requiring
access to the ext4 partition.

A working Raspbian system is required for bootstrap purposes.

## Acknowledgements

A sideways look at Bytemarks's
[pi-init2](https://github.com/BytemarkHosting/pi-init2) was taken to
see how other people solve this problem.

## Quick Setup

Mount the vfat partition of the Raspberry Pi that you wish to perform
the first-boot setup on. 

On the running Raspbian system from which you are bootstrapping,
install `busybox-static` and copy `/bin/busybox` to the root of the
vfat partition that was just mounted.

Copy the script `raspi-hacks.sh` from this repository to the root of
the vfat partition.

Make a copy of `cmdline.txt` in the vfat partition called
`cmdline.txt.new`. Modify the parameters in the original `cmdline.txt`
file which look like this:

`root=/dev/mmcblk0p2 rootfstype=ext4`

to something like this:

`root=/dev/mmcblk0p1 rootfstype=vfat rootflags=umask=000`

(This makes the assumption that the parition layout of your SD card is
the default Raspbian layout, i.e. that the vfat boot partition is the
first on disk, and the ext4 root partition is the second.)

Put the SD card into a Raspberry Pi and boot it up. With a bit of good
luck, it should boot, write the string "Hello, World!" to a file
called `/hello` on the root filesystem, and then reboot into the
normal Raspbian system.

## Details

The statically linked version of [busybox](https://busybox.net) is
used (in the intended "swiss-army knife" manner) to provided the
commands needed to run `raspi-hacks.sh` in an environment where
standard Unix utilities aren't available. This shell script mounts the
root filesystem, performs initialisation tasks, modifies boot
configuration and then reboots.


