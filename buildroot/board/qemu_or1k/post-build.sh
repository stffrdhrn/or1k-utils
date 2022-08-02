#!/bin/sh

TARGET_DIR=$1

## Add additional mount points for a virt cow2fs matching the following layout

# Device  Boot StartCHS    EndCHS        StartLBA     EndLBA    Sectors  Size Id Type
# /dev/vda1    0,1,1       1023,15,63          63    4194366    4194304 2048M 82 Linux swap
# /dev/vda2    1023,15,63  1023,15,63     4194367   16777215   12582849 6143M 83 Linux

# Then partitions populated with
# mkswap /dev/vda1
# dd if=/home/shorne/work/openrisc/buildroot/output/images/rootfs.ext4 of=/dev/vda2 bs=4096
# resize2fs /dev/vda2

mkdir -p $TARGET_DIR/boot

grep -v "^/dev/vda" $TARGET_DIR/etc/fstab > $TARGET_DIR/etc/fstab.tmp
mv $TARGET_DIR/etc/fstab.tmp $TARGET_DIR/etc/fstab

echo -e "/dev/vda1\tswap\tswap\tdefaults\t0\t0" >> $TARGET_DIR/etc/fstab
echo -e "/dev/vda2\t/\text4\trw,noauto\t0\t1" >> $TARGET_DIR/etc/fstab


