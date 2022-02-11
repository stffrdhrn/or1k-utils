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
fi

if [ "$BUILD_MANY_COMPILERS" ] ; then
  $SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD compilers $OTHER
  $SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD compilers $COMPILER
fi

$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD   glibcs    $OTHER
$SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD   glibcs    or1k-linux-gnu-soft

# If we support hardfloat toolchains define HARD_FLOAT to build them
if [ "$HARD_FLOAT" ]; then
  $SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD   glibcs    or1k-linux-gnu-hard
  $SRC/glibc/scripts/build-many-glibcs.py --keep failed $BUILD   glibcs    or1k-linux-gnu-hard64
fi

if [ "$MAILTO" ] ; then
  summary | mail -s "Build many report $(date +"%Y-%m-%d-%H:%M") - $(success_or_failure)" $MAILTO
fi
