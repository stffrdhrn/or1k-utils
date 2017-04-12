#!/bin/bash

TEST=$1
if [ ! -f "$TEST" ] ; then
  echo "Cant execute script '$TEST'"
  echo "Usage: $0 <test script>"
  exit 1
fi

BINDIR=$(dirname $0)

. $BINDIR/../config
OPENRISC_OS=$BINDIR/..

# Start sim in the background
sim -f $OPENRISC_OS/or1ksim.cfg $LINUX/vmlinux --nosrv &
SIM_PID=$$

# Run the expect test
$TEST

kill $SIM_PID
