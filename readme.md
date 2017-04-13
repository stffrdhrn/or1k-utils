# Openrisc OS Utilities
This is a collection of utilties that help with testing and running Linux,
GDB with openrisc. Most of these tools used to live in other repo's like
`openrisc/linux` and `openrisc/or1k-src`, but as we move to upstream things
we need a new home for these.

Currently this contains:
 - `site.exp` and `boards` - dejagnu test files from `or1k-src`
 - `or1ksim.cfg` - or1ksim configuration from `linux`
 - `initramfs` and `build.sh` - initramfs from `linux` and a script for
   building your own from new binaries
 - `openocd` - custom openocd board files for testing smp systems.
   Currently can be used with `stffrdhrn/openocd` mutlicore patches.
 - `tests` - some expect script for building kernel self tests loading them
   into the initramfs running them on the simulator and verifying they
   work.

## Initramfs
This is a simple tool for building a linux initramfs  image that can
boot on openrisc systems.

Currently this contains binaries built with or1k-gcc 5.4.0 for:
 - BusyBox 1.26.0
 - musl libc 1.1.16
 - strace 4.13

### Building
Just run the `build.sh` script.  The script will pull in a few
resources to build the initramfs.

 - `BUSYBOX` - the location of your prebuild static linked busybox install
 - `LIBC`    - the location of your libc binary

Then inside linux config point your initramfs to this repo.

### Using

When building linux you can make using the following

```
export OR1K_UTILS=../openrisc/or1k-utils

make -j5 \
  ARCH=openrisc \
  CROSS_COMPILE=or1k-linux- \
  CONFIG_INITRAMFS_SOURCE="$OR1K_UTILS/initramfs \
    $OR1K_UTILS/initramfs.devnodes"
```

This tells the linux build to pull int the initramfs from the sources in
the `or1k-utils` project.

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
