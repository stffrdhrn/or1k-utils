#!/bin/bash

## Prerequisites
# - A local or1k-linux-musl toolchain installed (get one at stffrdhrn/gcc)
# - A GCC 7.2.0 toolchain for comparing (from openrisc/or1k-gcc)
# - Qemu or1k user mode install

DIR=`dirname $0`

# Local latest install of GCC
GCC_LOCAL=or1k-linux-musl-gcc
LDPATH_ROOT_LOCAL=/opt/shorne/software

# GCC 7 (supposed to be better/faster?)
GCC_7=${DIR}/or1k-linux-musl/bin/or1k-linux-musl-gcc
LDPATH_ROOT_7=${DIR}

if [ "$1" == "7" ] ; then
  echo "Running GCC 7 test..."
  CC=${GCC_7}
  LDPATH=${LDPATH_ROOT_7}/or1k-linux-musl/or1k-linux-musl
else
  echo "Running GCC local test..."
  CC=${GCC_LOCAL}
  LDPATH=${LDPATH_ROOT_LOCAL}/or1k-linux-musl/or1k-linux-musl
  CFLAGS='-msfimm -mshftimm'
fi
echo "LDPATH=$LDPATH"
echo
${CC} --version
echo

make CC=${CC} XCFLAGS="-mhard-float -mhard-div -mhard-mul ${CFLAGS}" PORT_DIR=linux compile

~/work/openrisc/qemu/build/or1k-linux-user/qemu-or1k -L $LDPATH ./coremark.exe
