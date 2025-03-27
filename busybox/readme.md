# Busybox

This directory contains some binaries and tools for building a
[busybox](https://busybox.net) initramfs that can help boot an openrisc linux
system.

Currently this contains binaries built with or1k-gcc 5.4.0 and:
 - BusyBox 1.26.0
 - musl libc 1.1.16
 - strace 4.13

### Re-Building

If you want to refresh the binaries under `initramfs/` you can rebuild
from an existing busybox build.

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
  CONFIG_INITRAMFS_SOURCE="$OR1K_UTILS/busybos/initramfs \
    $OR1K_UTILS/busybox/initramfs.devnodes"
```

This tells the linux build to pull in the initramfs from the sources in
the `or1k-utils` project.


