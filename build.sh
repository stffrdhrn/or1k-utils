#!/bin/bash
#
# Script for building the intiramfs
#  user arg: clean to clean anything this does

BINDIR=$(dirname $0)
. $BINDIR/config

KSELFTESTS=$LINUX/tools/testing/selftests/install

# clean
if [ "$1" = 'clean' ] ; then

  rm -rf initramfs/bin
  rm -rf initramfs/sbin
  rm -rf initramfs/usr/bin
  rm -rf initramfs/usr/sbin
  rm -rf initramfs/lib
  rm -rf initramfs/kselftests
  rm initramfs/init

  exit 0
fi


if [ -d $BUSYBOX ] ; then
 echo "Installing busybox"
 cp -a $BUSYBOX/* initramfs/

 # Init just drops us to the shell
 echo "Installing init"
 ln -sf sbin/init initramfs/init

else
 echo "Cannot find busybox install in '$BUSYBOX', aborting"
 exit 1
fi

if [ -f $LIBC ] ; then
 echo "Installing lib"
 mkdir -p initramfs/lib
 cp $LIBC initramfs/lib
 ln -sf libc.so initramfs/lib/ld-musl-or1k.so.1

else
 echo "Cannot find libc at '$LIBC' install not completed"
 exit 1
fi

# Optional Kernel self tests
if [ -d $KSELFTESTS ] ; then
 echo "Installing kselftests"
 mkdir -p initramfs/kselftests
 cp -a $KSELFTESTS/* initramfs/kselftests/
fi

# Build initramfs, currently openrisc cannot use this
#DIR=$PWD
#pushd $LINUX
# ./scripts/gen_initramfs_list.sh -o $DIR/initramfs.cpio $DIR/initramfs $DIR/initramfs.devnodes
#popd

exit 0
