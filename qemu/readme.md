# Config and Build scripts for OR1K QEMU

Mostly you can use upstream qemu, but the or1k-glibc
branch has some patches for:

- FPU flag access in userspace that are not yet in the spec.
- Generating an or1ksim devicetree and passing directly to linux.
- Rootfs loading

```
$ git clone git@github.com:stffrdhrn/qemu.git or1k-glibc
$ cd qemu
$ mkdir build
$ ../../or1k-utils/qemu/config.qemu
$ make
```

There is also a stack config script which is used for building a qemu binary for
running qemu in a chroot environment with the linux
[binfmt_misc](https://en.wikipedia.org/wiki/Binfmt_misc) module.  However, this
is no longer maintained.

## Running OR1K in qemu

Assuming you have a kernel installed at `$HOME/work/linux/vmlinux`, run

```
$ ../../or1k-utils/scripts/qemu-or1k-linux
```
