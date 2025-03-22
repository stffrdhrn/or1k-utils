# GLIBC build scripts for OpenRISC

These are a bunch of build and test reporting scripts I put
together for building and testing the openrisc glibc port.
They were since adapted to also be used for newlib and musl
builds.

This will build the toolchain used for building other software.

## Setup

TODO, download the glibc, gcc and binutils-gdb projects and put them
into `$HOME/work/gnu-toolchain`, if you want to put them somewhere
else update `glibc.config`.

## Building the glibc toolchain

```
  git clone git://gcc.gnu.org/git/gcc.git gcc
  git clone git://sourceware.org/git/binutils-gdb.git binutils-gdb
  git clone git://sourceware.org/git/glibc.git glibc
```

To build run:

```
 ./glibc.build
```

This will install your toolchain to `$HOME/work/gnu-toolchain/local`.

There are also build scripts for tools that will use the toolchain.

```
  ./zlib.build       # build zlib used for other things
  ./coreutils.build  # build ls etc
  ./bash.build       # build bash
  ./dropbear.build   # build dropbear, ssh
  ./strace.build     # build strace for debugging
  ./glibc.build.binutils-native # build native gdb for host native debuggin'
```

## Building the newlib toolchain

```
  git clone git://sourceware.org/git/newlib-cygwin.git newlib
```

```
 ./newlib.build
```

## Building the musl toolchain

```
 git clone https://github.com/richfelker/musl-cross-make.git
```

```
 ./musl.build
```

## Testing glibc

There are also scripts for running the glibc test suite.  We have a few
ways to test:

- QEMU user mode - emulates openrisc code but syscalls run on your x86 linux kernel
- QEMU user chroot - like usermode but runs in a chroot environment using binfmt
- SSH remote - run tests via SSH on a qemu or real hardware target

The recommended option is to use `SSH remote`, to do this you will need
to have linux running on qemu or a FPGA.  The recommented rootfs to use
for linux is buildroot setup as described in `or1k-utils/buildroot`.

```
  # Examples running on ssh
  SSH=10.0.0.5 ./glibc.test                      # run all tests
  SSH=10.0.0.5 ./glibc.test nptl                 # run nptl tests
  SSH=10.0.0.5 ./glibc.test nptl/tst-cancel24    # run single test

  # Export CHROOT to use chroot environment, expects sysroot setup in
  # $HOME/work/gnu-toolchain/sysroot
  # QEMU must be installed as per glibc.config and your kernel needs to be
  # configured with binfmt
  # Then you can use this script to build the chroot ./glibc.make.chroot
  # No guarantee's you should know what you are doing to use this
  CHROOT=1 ./glibc.test

  # Default uses QEMU user mode
  ./glibc.test
```

Note: glibc itself has a different set of scripts which I should probably
switch over to.
