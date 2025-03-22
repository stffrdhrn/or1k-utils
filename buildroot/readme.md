## Building

```
$ git clone git@github.com:stffrdhrn/buildroot.git buildroot
$ cd buildroot
$ cp ../or1k-utils/buildroot/local.mk .
$ make BR2_EXTERNAL=../or1k-utils/buildroot/ litex_mor1kx_defconfig
$ make
```

### For TFTP boot

Copy the rootfs for litex tftp to boot

```
or1k_utils=$HOME/work/openrisc/or1k-utils

echo "Copying rootfs.cpio.gz to $or1k_utils/litex/tftpd/"
ls -lh output/images/
cp output/images/rootfs.cpio.gz $or1k_utils/litex/tftpd/
```

### For SD-Card

Copy rootfs to your partition


```
sudo dd if=output/images/rootfs.ext2 of=/dev/sdd3
```

### For QEMU Virt

Build using the `qemu_or1k_defconfig` config.

Then build a qemu rootfs with swap.  Run `qemu-or1k-mkimg`.
