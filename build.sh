#!/bin/bash
#
# Script for building the intiramfs
#  user arg: clean to clean anything this does

BUSYBOX=$HOME/work/openrisc/busybox/_install
LIBC=/opt/shorne/software/or1k-musl/or1k-linux-musl/or1k-linux-musl/lib/libc.so

# clean
if [ "$1" = 'clean' ] ; then

  rm -rf initramfs/bin
  rm -rf initramfs/sbin
  rm -rf initramfs/usr/bin
  rm -rf initramfs/usr/sbin
  rm -rf initramfs/lib
  rm initramfs/init

  exit 0
fi


if [ -d $BUSYBOX ] ; then
 echo "Installing busybox"
 cp -a $BUSYBOX/* initramfs/
 
 # Init just drops us to the shell
 echo "Installing init"
 ln -s sbin/init initramfs/init

else
 echo "Cannot find busybox install in '$BUSYBOX', aborting"
 exit 1
fi

if [ -f $LIBC ] ; then
 echo "Installing lib"
 mkdir -p initramfs/lib
 cp $LIBC initramfs/lib
 ln -s libc.so initramfs/lib/ld-musl-or1k.so.1

else
 echo "Cannot find libc at '$LIBC' install not completed"
 exit 1
fi

exit 0
