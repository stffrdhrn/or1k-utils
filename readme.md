# OpenRISC OS Utilities
This is a collection of utilities that help with testing and running Linux,
GDB with OpenRISC. Most of these tools used to live in other repo's like
`openrisc/linux` and `openrisc/or1k-src`, but as we move to upstream things
we need a new home for these.

Here you can find:

 - [TODO](TODO.md) - If you are interested in working on OpenRISC check out this list.
 - `site.exp` and `boards` - dejagnu test files for testing gcc with gdb/sim or QEMU, see usage in [or1k-toolchain-build](https://github.com/stffrdhrn/or1k-toolchain-build/blob/master/or1k-toolchain-build/build-gcc.sh).
 - `or1ksim.cfg` - or1ksim configuration for running [or1ksim](https://github.com/openrisc/or1ksim)
 - [busybox](busybox) - initramfs structure and scripts for building a
    busybox linux initramfs, see usage in [or1k-rootfs-build](https://github.com/stffrdhrn/or1k-rootfs-build).
 - [buildroot](buildroot) - configs and rootfs overlays for building an OpenRISC
    rootfs that can run on QEMU or a Litex SoC FGPA board, see usage in `or1k-rootfs-build`.
 - [qemu](qemu) - scripts for building the qemu system simulator.
 - [toolchains](toolchains) - scripts for building `newlib`, `glibc` and `musl`
   toolcchains.  See usage in `or1k-toolchain-build`.
 - [litex](litex) - tools and scripts for building and booting [litex](https://github.com/litex-hub) SoC FPGA
   boards.
 - `openocd` - custom [openocd](https://openocd.org) board files for debugging (JTAG) OpenRISC hardware.
   Currently can be used with `stffrdhrn/openocd` mutlicore patches.
 - [scripts](scripts) - convenience wrappers for building Linux, running QEMU etc.
 - [tests](tests) - some expect script for building kernel self tests loading them
   into the initramfs running them on the simulator and verifying they
   work.

## Dejagnu Testing

As mentioned above the `site.exp` and `boards` files used for [dejagnu](https://www.gnu.org/software/dejagnu/manual/index.html)
testing of gnu projects like gdb.

To use this run something like the following, this tells gdb to use or1ksim
as the target for running tests:

```bash
export DEJAGNU=$HOME/openrisc/or1k-utils/site.exp

cd build-gdb/gdb
# Run tests
make check

# or to just run a single test
make check RUNTESTFLAGS='gdb.xml/tdesc-regs.exp'

# or in GCC run
make check-gcc RUNTESTFLAGS='or1k.exp'
```

## See also

 - [busybox](https://busybox.net) - UNIX utilities in a single small executable, useful to create a Linux initramfs
 - [buildroot](https://buildroot.org/) - for much more advanced initramfs creation
 - [openadk](https://openadk.org/) - support for OpenRISC, uclibc, musl-cross
