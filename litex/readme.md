# Litex build scripts

## Setup

Look at the scripts, before you can use them we need to first do the `litex` setup and download
`litex-boards`.  These scripts expect these to be installed into `$HOME/work/litex/litex`
and `$HOME/work/litex/litex-boards`

For example:

```bash
mkdir $HOME/work/litex
cd $HOME/work/litex
git clone git@github.com:enjoy-digital/litex.git

wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
chmod +x litex_setup.py
./litex_setup.py init install --user # --user to install to user directory
```

Later to update litex do:

```bash
cd $HOME/work/litex
./litex_setup.py update
```

## Building (For arty)

To build the bitstream and bios.

```
 ./litex.build --build
```

## Programming

To load the bitstream and bios to the arty dev board using OpenOCD.

```
 ./litex.build --load
```

## Booting over Ethernet

The litex bios looks for a tftpd server running on `192.168.1.100` to
serve the linux kernel.  This is recommended for linux when you don't have
an SDcard etc as serial is too slow.

First:
  - Build the linux kernel using `or1klitex_defconfig` and copy `vmlinux.bin` into `tftpd/` as
   is created in [make-or1k-linux](/scripts/make-or1k-linux)
   - If you need a toolchain try: http://shorne.noip.me/downloads/or1k-smh-linux-gnu-11.0.0-20201219.tar.gz
  - Copy `rootfs.cpio.gz` into `tftpd/` as is done in the [buildroot](/buildroot/readme.md) build
   - Or get a prebuild image from: http://shorne.noip.me/downloads/or1k-glibc-rootfs.cpio.gz

Building the kernel can be done with the following:

```
cd path-to/linux

make clean
make ARCH=openrisc or1klitex_defconfig

make -j5 ARCH=oepnrisc CROSS_COMPILE=or1k-smh-linux-gnu-
cp arch/openrisc/boot/vmlinux.bin path-to/or1k-utils/litex/tftpd/boot.bin
```

There is a `boot.json` file that the litex bootloader uses to
load the kernel and rootfs to the right locations.

```
IF=enp0s31f6

#Extra IP for fpga dev
DEV_IP=192.168.1.100

ip addr add ${DEV_IP}/24 dev ${IF}

./litex.tftpd
```

## Also here

We can also use `litex-buildenv`, for that use:

```
 . ./enter-litex-buildenv
```
