# Litex tftpd

Originally this was done

First:
  - Copy linux `vmlinux` into tftpd as is done in [make-or1k-linux](/scripts/make-or1k-linux)
  - Copy `rootfs.cpio.gz` into tftpd as is done in the [buildroot](/buildroot/readme.md) build.

There is a `boot.json` file that the litex bootloader uses to
load the kernel and rootfs to the right locations.

```
IF=enp0s31f6

#Extra IP for fpga dev
DEV_IP=192.168.100.100

ip addr add ${DEV_IP}/24 dev ${IF}

/usr/sbin/in.tftpd --verbose --listen --address 192.168.100.100:6069 --user shorne -s tftpd/
```
