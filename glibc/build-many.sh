#!/bin/sh

DIR=`dirname $0`
source $DIR/glibc.config

BUILD=${BUILDDIR}/build-many
SRC=${BUILD}/src/

branch=or1k-glibc-2

if [ "$BUILD_MANY_SETUP" ] ; then
  mkdir -p $SRC
  [ ! -L $SRC/glibc ]    && ln -s $DIR/glibc $SRC/glibc
  [ ! -L $SRC/gcc ]      && ln -s $DIR/gcc $SRC/gcc
  [ ! -L $SRC/binutils ] && ln -s $DIR/binutils-gdb $SRC/binutils

  $SRC/glibc/scripts/build-many-glibcs.py $BUILD checkout \
    gcc-vcs-mainline \
    binutils-vcs-mainline \
    glibc-vcs-${branch}

  $SRC/glibc/scripts/build-many-glibcs.py $BUILD host-libraries
fi

$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD compilers or1k-linux-gnu or1k-linux-gnu-soft
$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD glibcs or1k-linux-gnu or1k-linux-gnu-soft
