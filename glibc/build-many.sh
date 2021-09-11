#!/bin/sh

DIR=`dirname $0`
source $DIR/glibc.config

BUILD=${BUILDDIR}/build-many
SRC=${BUILD}/src/

branch=or1k-glibc-2
#binutils_branch=mainline
gcc_branch=releases/gcc-10
binutils_branch=or1k-gdbserver-nat

if [ "$BUILD_MANY_SETUP" ] ; then
  mkdir -p $SRC
  [ ! -L $SRC/glibc ]    && ln -s $BUILDDIR/glibc $SRC/glibc
  [ ! -L $SRC/gcc ]      && ln -s $BUILDDIR/gcc $SRC/gcc
  [ ! -L $SRC/binutils ] && ln -s $BUILDDIR/binutils-gdb $SRC/binutils
  #[ ! -L $SRC/gmp ]      && ln -s $BUILDDIR/gmp-6.1.2 $SRC/gmp
  #[ ! -L $SRC/mpc ]      && ln -s $BUILDDIR/mpc-1.0.3 $SRC/mpc
  #[ ! -L $SRC/mpfr ]     && ln -s $BUILDDIR/mpfr-3.1.5 $SRC/mpfr

  $SRC/glibc/scripts/build-many-glibcs.py $BUILD checkout \
    gcc-vcs-${gcc_branch} \
    binutils-vcs-${binutils_branch} \
    glibc-vcs-${branch}

  $SRC/glibc/scripts/build-many-glibcs.py $BUILD host-libraries

  $SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD compilers i686-gnu i686-gnu
  #$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD compilers or1k-linux-gnu or1k-linux-gnu-soft
fi

#$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD glibcs    or1k-linux-gnu or1k-linux-gnu-soft

$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD glibcs    i686-gnu i686-gnu
