# Openrisc OS Utilities
This is a collection of utilties that help with testing and running Linux,
GDB with openrisc. Most of these tools used to live in other repo's like
`openrisc/linux` and `openrisc/or1k-src`, but as we move to upstream things
we need a new home for these.

Currently this contains:
 - `site.exp` and `boards` - dejagnu test files from `or1k-src`
 - `or1ksim.cfg` - or1ksim configuration from `linux`
 - `busybox` - initramfs structure and binaries for building a
    busybox linux initramfs.
 - `buildroot` - configs and rootfs overlays for building an openrisc
    rootfs that can run on QEMU or a Litex SoC FGPA board.
 - `toolchains` - scripts for building `newlib`, `glibc` and `musl`
   toolcchains.
 - `litex` - tools and scripts for building and booting litex SoC FPGA
   boards.
 - `openocd` - custom openocd board files for debugging (JTAG) smp hardware.
   Currently can be used with `stffrdhrn/openocd` mutlicore patches.
 - `scripts` - convenience wrappers for building linux, running qemu etc.
 - `tests` - some expect script for building kernel self tests loading them
   into the initramfs running them on the simulator and verifying they
   work.

## Dejagnu Testing

Also available here is the `site.exp` and `boards` files used for dejagnu
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

 - [buildroot](https://buildroot.org/) - for much more advanced initramfs creation
 - [openadk](https://openadk.org/) - support for openrisc, uclibc,
   musl-cross
