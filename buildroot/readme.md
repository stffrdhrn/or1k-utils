## Building

```
$ git clone git@github.com:stffrdhrn/buildroot.git or1k-glibc
$ cd buildroot
$ make BR2_EXTERNAL=../or1k-utils/buildroot/ litex_mor1kx_defconfig
$ make
```

Copy the rootfs for litex tftp to boot

```
echo "Copying rootfs.cpio.gz to $HOME/work/litex/litex-buildenv/build/tftpd/"
ls -lh output/images/
cp output/images/rootfs.cpio.gz $HOME/work/litex/litex-buildenv/build/tftpd/
```
