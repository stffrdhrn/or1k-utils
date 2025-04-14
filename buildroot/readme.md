In this directory we have some default configs and filesystem setup for creating
a buildroot rootfs used when running OpenRISC on linux.

The buildroot rootfs can be thought of as a Linux distribution for
embedded systems, it will contain a runtime such as glibc or musl and
 programs like `bash`, `grep`, `ssh`, your editor of choce etc.

We provide different configs:

 - litex_mor1kx_defconfig - for [litex](https://github.com/enjoy-digital/litex) SoCs running on FPGA boards, uses musl libc
 - qemu_or1k_defconfig - for the QEMU virt machine, which we use for glibc testing
 - qemu_or1k_shorne_defconfig - for the QEMU virt machine, which I use with glibc testing setting up my user
                                for sharing and NFS drive with my host machine

## Building

An example of how to get buildroot and build a rootfs can be found below.

```
# Assuming we have `or1k-utils` in $HOME/work/openrisc

cd $HOME/work/openrisc
git clone https://gitlab.com/buildroot.org/buildroot.git buildroot

./or1k-utils/buildroot/buildroot.build litex_mor1kx_defconfig
./or1k-utils/buildroot/buildroot.build
```

When done we will have a rootfs saved to `$HOME/work/openrisc/buildroot-rootfs`. For example:

```
$ ls -l ./buildroot-rootfs/
total 62796
-rw-r--r--. 1 oruser oruser 19048105 Apr  3 16:45 litex-mor1kx-rootfs.cpio.gz
-rw-r--r--. 1 oruser oruser 62914560 Apr  3 16:45 litex-mor1kx-rootfs.ext2
```

## Using

Once you get in there are some defaults:

### Defaults for the qemu rootfs

| Config   | Value                         | Comment |
| -------- | ----------------------------- | ------- |
| Admin    | user: `root`, password: none  |       |
| IP       | `10.9.0.15`                   | For qemu userspace networking |
| Netmask  | `255.255.255.0`               |       |
| Gateway  | `10.9.0.100`                  |       |
| DNS      | `10.9.0.3`                    |       |

### Defaults for the litex rootfs

The arty a7 board plugs into a switch on my workstation subnet
and is setup with the following.

| Config   | Value                         | Comment |
| -------- | ----------------------------- | ------- |
| Admin    | user: `root`, password: none  |       |
| IP       | `10.0.0.5` | Example from my lan subnet see: [stffrdhrn/hostconfig](https://github.com/stffrdhrn/hostconfig/blob/master/raspian/setup.md#routing) |
| Netmask  | `255.255.255.0` |       |
| Gateway  | `10.0.0.31` | My raspberry pi |
| DNS      | `192.168.1.1` | DNS in other subnet |

## Building with a custom toolchain

If you want to use a custom compiler, libc or binutils version
you can override the stable versions with local sources using a `local.mk`
file as seen below.  There is an example `local.mk` file included in `or1k-utils`.

```
$ git clone https://gitlab.com/buildroot.org/buildroot.git buildroot
$ cd buildroot
$ cp ../or1k-utils/buildroot/local.mk .
$ make BR2_EXTERNAL=../or1k-utils/buildroot/ litex_mor1kx_defconfig
$ make
```

### For Litex TFTP boot

For Litex boots that load a rootfs over tftp the rootfs will need
to be copied to the `tftpd/` server directory.  The `or1k-utils/litex`
directory has tools for starting the `tftpd` server.

To copy the rootfs for the litex tftp boot do:

```
# Assuming we have `or1k-utils` in $HOME/work/openrisc

cd $HOME/work/openrisc

echo "Copying rootfs.cpio.gz to $or1k_utils/litex/tftpd/"
ls -lh buildroot-rootfs/
cp buildroot-rootfs/litex-mor1kx-rootfs.cpio.gz ./or1k-utils/litex/tftpd/
```

### For Litex SD-Card (recommended)

If your litex FPGA board has an SD-Card, it's recommended to
copy your rootfs to a partitioned SD-Card as below.

See `litex_mor1kx/post-build.sh` for details on what the
partition structure should look like for your SD-Card. In general it is:

 - p0 - FAR32 - used by litex
 - p1 - swap - linux swap, needed as most board don't have much memory
 - p2 - rootfs - place for the rootfs, mounted /
 - p3 - space - extra space, mounted /root

Note: You may still use tftpd boot for loading a development Linux kernel.  In
this case set the `tftpd/Makefile` `ROOTFS` config to `disabled`, to avoid
loading both a `tftp` and SD-Card rootfs.

With the SD-Card plugged into your workstation, copy the rootfs to your SD-Card
partition with:

```
# Assuming we have `or1k-utils` in $HOME/work/openrisc

echo "Copying rootfs.cpio.gz to $or1k_utils/litex/tftpd/"
ls -lh buildroot-rootfs/
sudo dd if=buildroot-rootfs/litex-mor1kx-rootfs.ext2 of=/dev/sdd3
```

### For QEMU Virt

Build using the `qemu_or1k_defconfig` config to create an image that
can be used with qemu.  You can then run linux with that image by using
`qemu-or1k-linux`.

The build will create a qemu rootfs with swap by running `qemu-or1k-mkimg`.
For example:

```
# Assuming we have `or1k-utils` in $HOME/work/openrisc

cd $HOME/work/openrisc
git clone https://gitlab.com/buildroot.org/buildroot.git buildroot

# First clean in case we build litex_mor1kx_defconfig before
./or1k-utils/buildroot/buildroot.build clean
./or1k-utils/buildroot/buildroot.build qemu_or1k_defconfig
./or1k-utils/buildroot/buildroot.build
```
