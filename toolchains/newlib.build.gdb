#!/bin/bash

set -e

DIR=`dirname $0`
source $DIR/newlib.config

mkdir -p $BUILDDIR/build-gdb
# Clear anything inside, but don't delete the directory incase its mounted
# in our chroot.
rm -rf $BUILDDIR/build-gdb/*

pushd  $BUILDDIR/build-gdb

    $GDB_SRC/configure \
     --without-gprof \
     --without-zlib \
     --disable-ld \
     --disable-gas \
     --disable-binutils \
     --prefix=$INSTALLDIR \
     --target=$CROSS &&
    make -j${THREADS} &&
    make install

popd
