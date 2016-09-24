# Openrisc OS
This is a simple tool for building a linux initramfs  image that can
boot on openrisc systems.

## Install
Just run the `build.sh` script.  The script will pull in a few
resources to build the initramfs. 

 - `BUSYBOX` - the location of your prebuild static linked busybox install
 - `LIBC`    - the location of your libc binary

Then inside linux config point your initramfs to this repo.

## See also

 - [buildtoot](https://buildroot.org/) - for much more advanced initramfs creation
