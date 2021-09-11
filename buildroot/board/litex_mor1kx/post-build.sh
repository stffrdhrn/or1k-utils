#!/bin/sh

TARGET_DIR=$1

## Add additional mount points for our SD card matching the following layout

# Device     Boot   Start      End Sectors   Size Id Type
# /dev/sdd1  *         63  1000000  999938 488.3M  b W95 FAT32
# /dev/sdd2       1001472  4909055 3907584   1.9G 82 Linux swap / Solaris
# /dev/sdd3       4909056  5984255 1075200   525M 83 Linux (rootfs)
# /dev/sdd4       5984256 15523839 9539584   4.5G 83 Linux (free space)

mkdir -p $TARGET_DIR/boot

grep -v "^/dev/mmcblk0" $TARGET_DIR/etc/fstab > $TARGET_DIR/etc/fstab.tmp
mv $TARGET_DIR/etc/fstab.tmp $TARGET_DIR/etc/fstab

echo -e "/dev/mmcblk0p1\t\t/boot\tvfat\tdefaults\t\t0\t0" >> $TARGET_DIR/etc/fstab
echo -e "/dev/mmcblk0p2\t\tswap\tswap\tdefaults\t\t0\t0"  >> $TARGET_DIR/etc/fstab
echo -e "/dev/mmcblk0p3\t\t/\text4\trw,noauto\t\t0\t1" >> $TARGET_DIR/etc/fstab
echo -e "/dev/mmcblk0p4\t\t/root\text4\tdefaults\t\t0\t2" >> $TARGET_DIR/etc/fstab


