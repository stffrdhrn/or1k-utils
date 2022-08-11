#!/bin/bash

# Need to run all this as root

IMG=/home/shorne/work/openrisc/buildroot/output/images/rootfs.ext4
DEV=/dev/nbd0
QCOW2=or1k-rootfs.qcow2

qemu-img create -f qcow2 $QCOW2 8G

if ! lsmod | grep -q ^nbd ; then
  modprobe nbd max_part=8
fi

qemu-nbd --connect=$DEV $QCOW2

echo -e ',2G,s\n,,+\n' | sudo sfdisk $DEV
sfdisk --part-type $DEV 1 swap
sfdisk --part-type $DEV 2 linux

sfdisk --dump $DEV

mkswap ${DEV}p1
dd if=$IMG of=${DEV}p2 bs=4096
resize2fs ${DEV}p2

qemu-nbd --disconnect $DEV
