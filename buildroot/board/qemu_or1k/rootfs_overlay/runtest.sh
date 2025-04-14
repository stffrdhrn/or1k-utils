#!/bin/bash
#
# Run a glibc test with all the right parameters

# WORKING?
# - support strace
# - support coredump - path setup in S50setup.sh
# - support more args

GNU_ROOT=$HOME/work/gnu-toolchain
BUILD_GLIBC=$GNU_ROOT/build-glibc

LIBRARY_PATH="$BUILD_GLIBC"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/math"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/elf"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/dlfcn"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/nss"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/nis"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/rt"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/resolv"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/mathvec"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/support"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/crypt"
LIBRARY_PATH="$LIBRARY_PATH:$BUILD_GLIBC/nptl"
LIBRARY_PATH="$LIBRARY_PATH:$GNU_ROOT/sysroot/lib"

trace() {
  if [ -n "${TRACE}${DEBUG}" ] ; then
    echo "$(date -u +"%F %T") TRACE $@"
  fi
}

run() {
  trace "exec: $@"
  exec $@
}

if [ -n "$STRACE" ] ; then
  TEST_STRACE="strace -fo $GNU_ROOT/sysroot/tmp/strace.$$.txt"
fi

TEST_BIN=$1; shift
if [ ! -f "$TEST_BIN" ] ; then
  TEST_BIN=${BUILD_GLIBC}/$TEST_BIN
fi

if [ ! -f "$TEST_BIN" ] ;then
  echo "Error cannot execute: $TEST_BIN"
  echo "USAGE: $0 <TEST_BIN>"
  echo "Example: $0 nptl/tst-stack4"
  exit 1
fi

# Enable coredumps
export TEST_COREDUMPS=1
ulimit -c unlimited

run $TEST_STRACE $BUILD_GLIBC/elf/ld.so \
  --library-path $LIBRARY_PATH \
  $TEST_BIN $@
