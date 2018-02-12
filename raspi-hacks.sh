#!/busybox sh

# raspi-hacks.sh - PoC first-boot initialisation for Raspbian

# If this fails, you're out of luck

# Busybox provides *ALL* of our commands, but is *not* symlinked, so set 
# up aliases for the commands we need

cd /

bb="/busybox"

mount="$bb mount"
umount="$bb umount"
mkdir="$bb mkdir"
mknod="$bb mknod"
sync="$bb sync"
cat="$bb cat"
cp="$bb cp"
rm="$bb rm"
rmdir="$bb rmdir"
reboot="$bb reboot"
sleep="$bb sleep"
echo="$bb echo"
mv="$bb mv"

# Mount root filesystem as writable, then create a tmpfs directory in
# which we can create the device nodes we need to access the root
# partition

$mount -o remount,rw / / # Two slashes are essential!
$mkdir /tmp
$mkdir /new_root
$mount -t tmpfs tmpfs /tmp

# Access the root fs
$mknod /tmp/mmcblk0p2 b 179 2
$mount -o rw -t ext4 /tmp/mmcblk0p2 /new_root

# Set up the message
$cat > /new_root/hello <<EOF
Hello, World!
EOF

# Sync and unmount root fs
$sync
$umount /new_root
$rmdir /new_root

# Remove device node and tmp dir
$rm /tmp/mmcblk0p2
$umount /tmp
$rmdir /tmp

# Change the boot configuration
$mv -f /cmdline.txt /cmdline.txt.orig
$mv -f /cmdline.txt.new /cmdline.txt

# Print some messages
$echo "Configuration complete, sleeping 15 seconds"
$sleep 15

# Sync filesystems, mount read-only, and reboot
$sync
$mount -o remount,ro /
$sync
$reboot -f
