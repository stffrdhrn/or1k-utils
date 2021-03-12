# Litex build scripts

## Setup

Look at the scripts, before you can use them we need to first do the `litex` setup and download
`litex-boards`.  These scripts expect these to be installed into `$HOME/work/litex/litex`
and `$HOME/work/litex/litex-boards`

For example:

```bash
mkdir $HOME/work/litex
cd $HOME/work/litex

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

To build the bitstream, bios and linux device tree.

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

Building the kernel can also be done with the following:

```
cd path-to/linux

make clean
make ARCH=openrisc or1klitex_defconfig

make -j5 ARCH=oepnrisc CROSS_COMPILE=or1k-smh-linux-gnu-
cp arch/openrisc/boot/vmlinux.bin path-to/or1k-utils/litex/tftpd/boot.bin
```

The `tftpd/boot.json` file is used by litex bootloader to load the kernel,
device tree and rootfs to the right locations in the target ram.  A tftpd server
needs be to running to serve the files.  Start one up as follows:

```
IF=enp0s31f6

#Extra IP for fpga dev
DEV_IP=192.168.1.100

ip addr add ${DEV_IP}/24 dev ${IF}

./litex.tftpd
```

## Advanced Debugging

We can use a jtagbone or etherbone host bridge to access the SoC's wishbone bus from
your host computer.  From there we  can script several things.

For me this works with jtagbone as I want to use ethernet at the same time.

### BIOS reloading

Writes the bios directly to the SoC's rom and reloads.

```
./litex.run $PWD/reload-rom.py /home/shorne/work/litex/litex-boards/build/arty/software/bios/bios.bin && echo wait 30s && litex_term /dev/ttyUSB1
```

Just reboot the CPU and reconnect (not restarting the jtagbone etc)

```
./litex.run $PWD/reboot.py && echo wait 30s && litex_term /dev/ttyUSB1
```

### Getting it all setup

We need a few code changes to get the below to work.
  - Ensure rom is set to "rw" in arty.py
  - Ensure we have jtagbone on
  - Disable Full SoC reset

Steps explained below

```
15:42 < shorne> Is there a fast way to flash a new bios to the board?  If I make c changes and do " ./arty.py ..platform options.. --load " it doesn't update the bios
15:43 < shorne> I seem to have to do "./arty.py ...option... --build;  ./arty.py ...options... --load"  which requires waiting for the bitstream to build
15:44 < shorne> the --no-compile-gateware option doesn't seem to do anything 
15:56 < zyp> the bios is stored in blockram initialization in the bitstream so updating it requires either rebuilding the bitstream or rewriting the bitstream to 
             change blockram contents, and I don't think the latter is supported
16:04 < shorne> zyp: thats what I figured, but wasn't sure, thanks for clarifying
...

16:55 < _florent_> shorne: That's not supported directly in the LiteX-Targets, but it's possible to easily rebuild the BIOS and reload it
16:56 < _florent_> With a bridge in your SoC (for example JTAGBone in your case), you can set integrated_rom_mode to "rw": 
                   https://github.com/enjoy-digital/litedram/blob/master/bench/arty.py#L76
16:57 < _florent_> and then use a simple script to reload the ROM and reset the SoC: https://github.com/enjoy-digital/litedram/blob/master/bench/common.py#L95-L109
16:59 < _florent_> in case reseting the full SoC breaks the bridge, you could comment this: 
                   https://github.com/enjoy-digital/litex/blob/master/litex/soc/integration/soc.py#L939-L944
16:59 < _florent_> this will only reset the CPU and not the whole SoC
```

## Also here

We can also use `litex-buildenv`, for that use:

```
 . ./enter-litex-buildenv
```
