# Openrisc OS Utilities
This is a collection of utilties that help with testing and running Linux,
GDB with openrisc. Most of these tools used to live in other repo's like
`openrisc/linux` and `openrisc/or1k-src`, but as we move to upstream things
we need a new home for these.

Currently this contains:
 - `site.exp` and `boards` - dejagnu test files for testing gcc with gdb/sim or qemu, see usage in [or1k-toolchain-build](https://github.com/stffrdhrn/or1k-toolchain-build/blob/master/or1k-toolchain-build/build-gcc.sh)
 - `or1ksim.cfg` - or1ksim configuration for running [or1ksim](https://github.com/openrisc/or1ksim)
 - `busybox` - initramfs structure and binaries for building a
    busybox linux initramfs.
 - `buildroot` - configs and rootfs overlays for building an openrisc
    rootfs that can run on QEMU or a Litex SoC FGPA board.
 - `toolchains` - scripts for building `newlib`, `glibc` and `musl`
   toolcchains.
 - `litex` - tools and scripts for building and booting [litex](https://github.com/litex-hub) SoC FPGA
   boards.
 - `openocd` - custom [openocd](https://openocd.org) board files for debugging (JTAG) openrisc hardware.
   Currently can be used with `stffrdhrn/openocd` mutlicore patches.
 - `scripts` - convenience wrappers for building linux, running qemu etc.
 - `tests` - some expect script for building kernel self tests loading them
   into the initramfs running them on the simulator and verifying they
   work.

## Dejagnu Testing

As mentioned above the `site.exp` and `boards` files used for dejagnu
testing of gnu projects like gdb.

To use this run something like the following, this tells gdb to use or1ksim
as the target for running tests:

```
export DEJAGNU=$HOME/openrisc/or1k-utils/site.exp

cd build-gdb/gdb
# Run tests
make check

# or to just run a single test
make check RUNTESTFLAGS='gdb.xml/tdesc-regs.exp'
```

## See also

 - [busybox](https://busybox.net) - UNIX utilities in a single small executable, usefull to create a linux initramfs
 - [buildroot](https://buildroot.org/) - for much more advanced initramfs creation
 - [openadk](https://openadk.org/) - support for openrisc, uclibc,
   musl-cross
