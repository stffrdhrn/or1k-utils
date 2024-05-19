#!/bin/sh

DIR=`dirname $0`
source $DIR/glibc.config

BUILD=${BUILDDIR}/build-many
SRC=${BUILD}/src/

branch=or1k-glibc-2
#binutils_branch=mainline
gcc_branch=releases/gcc-10
binutils_branch=or1k-gdbserver-nat

# TODO BUILD_OTHER_COMPILERS
others="i686-gnu x86_64-linux-gnu riscv32-linux-gnu-rv32imac-ilp32 riscv64-linux-gnu-rv64imac-lp64"

start_time=`date -u +%s`

# Glibc needs to be built with -O2 to be clean
export CFLAGS="-g -O2"

OTHER=riscv32-linux-gnu-rv32imac-ilp32
#OTHER=x86_64-linux-gnu
#OTHER=arc-linux-gnu
#OTHER=sh4-linux-gnu

COMPILER=or1k-linux-gnu-soft
if [ "$HARD_FLOAT" ]; then
  COMPILER=or1k-linux-gnu
fi

log_files() {
  find $BUILD/logs/ -type f \
    -name '*or1k*log.txt' \
    -newer $BUILD/logs/compilers/$COMPILER/000-*-status.txt -exec ls {} \+
}

check_fail() {
  log_files | xargs grep ^FAIL:
}

success_or_failure() {
  if check_fail > /dev/null ; then
    echo -n FAILURE
  else
    echo -n SUCCESS
  fi
}

summary() {
  echo
  echo -n "# build finish:   "; date -Is
  log_files | xargs grep -h '^\(PASS\|FAIL\|UNRESOLVED\):'
  if check_fail > /dev/null ; then
     log_files | xargs grep -B15 ^FAIL:
  fi
  check_fail
  echo -n "# build time(m):  "; expr `date -u +%s` / 60 - $start_time / 60
  echo
}

usage() {
  echo "usage: $0 <command>"
  echo "available commands:"
  echo " setup     - create $SRC and pull all default sources from build-many-glibcs.py,"
  echo "             run when build-many versions change"
  echo " compilers - build compilers $OTHER and $COMPILER"
  echo " glibcs    - build glibcs after compilers $OTHER and or1k-linux-gnu-soft"
  echo " list      - list compilers and glibcs"
  exit 1
}

check_src() {
  if [ ! -d "$SRC/glibc" ] ; then
    echo "Missing $SRC/glibc, run '$0 setup' first."
    exit 1
  fi
}

send_report() {
  cmd=$1 ; shift

  if [ "$MAILTO" ] ; then
    summary | mail -s "Build many $cmd report $(date +"%Y-%m-%d-%H:%M") - $(success_or_failure)" $MAILTO
  fi
}

build_command=$1

if [ ! "$build_command" ] ; then
  usage
fi

# Do the buildmany checkout, use default versions
# from build-many-glibcs for everything but the stuff
# I work on.
# Note, if we run this again it will not do anything
# it only does checkout if version args change.
if [ "$build_command" == "setup" ] ; then
  rm -rf $BUILD
  mkdir -p $SRC
  [ ! -L $SRC/binutils ] && ln -s $BUILDDIR/binutils-gdb $SRC/binutils
  [ ! -L $SRC/glibc ]    && ln -s $BUILDDIR/glibc        $SRC/glibc
  [ ! -L $SRC/gcc ]      && ln -s $BUILDDIR/gcc          $SRC/gcc

  # Trick build-many-glibcs to use our versions and don't touch my dirs
  {
    echo '{'
    echo ' "binutils":{"explicit":true,"revision":"abc123","version":"vcs-mainline"}'
    echo ',"glibc":   {"explicit":true,"revision":"abc123","version":"vcs-mainline"}'
    echo ',"gcc":     {"explicit":true,"revision":"abc123","version":"vcs-mainline"}'
    echo '}'
  } > $SRC/versions.json

  $SRC/glibc/scripts/build-many-glibcs.py --shallow $BUILD checkout \
    glibc-vcs-mainline \
    binutils-vcs-mainline \
    gcc-vcs-mainline

  $SRC/glibc/scripts/build-many-glibcs.py -j12 $BUILD host-libraries
elif [ "$build_command" == "compilers" ] ; then
  check_src

  $SRC/glibc/scripts/build-many-glibcs.py -j12 --keep failed $BUILD compilers $OTHER
  $SRC/glibc/scripts/build-many-glibcs.py -j12 --keep failed $BUILD compilers $COMPILER

  send_report $build_command
elif [ "$build_command" == "glibcs" ] ; then
  check_src

  $SRC/glibc/scripts/build-many-glibcs.py -j12 --keep failed $BUILD   glibcs    $OTHER
  $SRC/glibc/scripts/build-many-glibcs.py -j12 --keep failed $BUILD   glibcs    or1k-linux-gnu-soft

  # If we support hardfloat toolchains define HARD_FLOAT to build them
  if [ "$HARD_FLOAT" ]; then
    $SRC/glibc/scripts/build-many-glibcs.py -j12 --keep failed $BUILD   glibcs    or1k-linux-gnu-hard
  fi

  send_report $build_command
elif [ "$build_command" == "list" ] ; then
  check_src

  echo "## COMPILERS ##"
  $SRC/glibc/scripts/build-many-glibcs.py $BUILD list-compilers
  echo "## GLIBCS ##"
  $SRC/glibc/scripts/build-many-glibcs.py $BUILD list-glibcs
else
  echo "Unknown command: $build_command"
  usage
fi


