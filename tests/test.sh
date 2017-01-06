#!/bin/bash
# This script helps with doing all test steps to run tests for the openrisc
# kernel. it will:
#  - build the kernel self tests
#  - install them in initramfs
#  - build kernel (initramfs)
#  - start target and run the tests

LINUX=$HOME/work/linux
CROSS_COMPILE=or1k-musl-linux-
TARGETS="futex sync timers"

BINDIR=$(dirname $0)

# Build self tests
pushd $LINUX
  make TARGETS="${TARGETS}" CROSS_COMPILE=${CROSS_COMPILE} -C tools/testing/selftests

  # Installs tests to $LINUX/tools/testing/selftests/install
  make TARGETS="${TARGETS}" -C tools/testing/selftests install
popd

# Build our initramfs
pushd $BINDIR/..
  ./build.sh
popd

# Build kernel
pushd $LINUX
  make ARCH=openrisc
popd

# Run expect tests
for exptest in $BINDIR/scripts/*.exp; do
  echo "Running $exptest..."
  $BINDIR/test-or1ksim.sh $exptest
done
