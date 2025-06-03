# Config and Build scripts for OR1K QEMU

These tools will help you build and run QEMU.

OpenRISC qemu patches are all upstream so use the upstream [qemu](https://www.qemu.org)
repo.  Below will just help you getting started for more details
check out the [QEMU system emulation](https://www.qemu.org/docs/master/system/index.html) documentation.

```
$ git clone https://gitlab.com/qemu-project/qemu.git
$ cd qemu
$ mkdir build
$ ../../or1k-utils/qemu/config.qemu
$ make
```

There is also a static config script which is used for building a qemu binary for
running qemu in a chroot environment with the linux
[binfmt_misc](https://en.wikipedia.org/wiki/Binfmt_misc) module.  However, this
is no longer maintained.

## Running OR1K in qemu

Assuming you have an OpenRISC at `$HOME/work/linux/vmlinux` and a rootfs
like one downloaded from
[or1k-rootfs-build](https://github.com/stffrdhrn/or1k-rootfs-build/releases)
binaries, run

```
$ ../../or1k-utils/scripts/qemu-or1k-linux
```
