#!/bin/sh

TARGET_DIR=$1

## Add additional mount points for a virt cow2fs matching the following layout

# Device  Boot StartCHS    EndCHS        StartLBA     EndLBA    Sectors  Size Id Type
# /dev/vda1    0,1,1       16,5,4              63      16446      16384 8192K 83 Linux
# /dev/vda2    16,5,5      32,8,8           16447      32767      16321 8160K 83 Linux


mkdir -p $TARGET_DIR/boot

grep -v "^/dev/vda" $TARGET_DIR/etc/fstab > $TARGET_DIR/etc/fstab.tmp
mv $TARGET_DIR/etc/fstab.tmp $TARGET_DIR/etc/fstab

echo -e "/dev/vda1\t\t/root\text4\tdefaults\t\t0\t1" >> $TARGET_DIR/etc/fstab
echo -e "/dev/vda2\t\t/home\text4\trw,noauto\t\t0\t1" >> $TARGET_DIR/etc/fstab


