#!/bin/bash
cd $(dirname $0)
ROOT=$PWD
echo ; echo Running tests in futex
echo ========================================
cd futex
./run.sh
cd $ROOT
echo ; echo Running tests in sync
echo ========================================
cd sync
(./sync_test && echo "selftests: sync_test [PASS]") || echo "selftests: sync_test [FAIL]"
cd $ROOT
