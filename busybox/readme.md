# Busybox

This directory contains tools for building a [busybox](https://busybox.net)
initramfs that can help boot an openrisc linux system.

### Building

Just run the `busybox.build` script.  The script will pull in a few
resources to build the initramfs from.

 - `CROSSTOOL`   - (default `or1k-buildroot-linux-musl-`) the toolchain prefix you use.
                   see [openrisc/software](https://openrisc.io/software) or the `toolchain`
                   directory for details on how to get a toolchain.
 - `BUSYBOX_SRC` - (default: `$HOME/work/openrisc`) the location of your busybox source

For example:

```
  # Assuming we have `or1k-utils` in $HOME/work/openrisc
  # and the toolchaiin is already in your PATH

  cd $HOME/work/openrisc
  git clone git://busybox.net/busybox.git
  export BUSYBOX_SRC=$HOME/work/openrisc/busybox

  /path/to/or1k-utils/busybox.build
```

### Using

When building linux you can make using the following

```
export ROOTFS=$HOME/work/openrisc/busybox-rootfs

# Configure with defconfig, see 'make ARCH=openrisc help' for other configs
make ARCH=openrisc CROSS_COMPILE=or1k-linux- defconfig

# Build the kernel
make -j5 \
  ARCH=openrisc \
  CROSS_COMPILE=or1k-linux- \
  CONFIG_INITRAMFS_SOURCE="$ROOTFS/initramfs $ROOTFS/initramfs.devnodes"
```

This tells the linux build to pull in the initramfs from the rootfs structure
we built above.
