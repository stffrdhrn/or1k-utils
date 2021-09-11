## Building

```
$ git clone git@github.com:stffrdhrn/buildroot.git or1k-glibc
$ cd buildroot
$ cp ../or1k-utils/buildroot/local.mk .
$ make BR2_EXTERNAL=../or1k-utils/buildroot/ litex_mor1kx_defconfig
$ make
```

Copy the rootfs for litex tftp to boot

```
or1k_utils=$HOME/work/openrisc/or1k-utils

echo "Copying rootfs.cpio.gz to $or1k_utils/litex/tftpd/"
ls -lh output/images/
cp output/images/rootfs.cpio.gz $or1k_utils/litex/tftpd/
```
