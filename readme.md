# Openrisc OS Utilities
This is a simple tool for building a linux initramfs  image that can
boot on openrisc systems.

## Install
Just run the `build.sh` script.  The script will pull in a few
resources to build the initramfs.

 - `BUSYBOX` - the location of your prebuild static linked busybox install
 - `LIBC`    - the location of your libc binary

Then inside linux config point your initramfs to this repo.

## Using

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
