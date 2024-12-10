#!/bin/bash

# A build runner to be used with glibc.  From the glibc directory run:
#  glibc.make <make-target>
#
# This will run 'make <make-target>' with the correct arguments to run glibc
# build as requested.  The SUBDIR argument is optional and will be used
# to limit the build to run only for the selected sub-directory.
#
# This is used for regen-ulps

DIR=`dirname $0`
source $DIR/glibc.config

TEST_WRAPPER="$DIR/qemu-or1k-libc"
TEST_WRAPPER="$(readlink -f $TEST_WRAPPER)"

pushd $BUILDDIR/build-glibc
    make -r PARALLELMFLAGS="-j4" \
test-wrapper=$TEST_WRAPPER objdir=`pwd` $@
popd
