# Misc Helper Scripts

This directory contains a bunch of helper scripts that
don't necessarily fit into the other directories or
just haven't been moved yet.

Some of these scripts are not really used anymore too.
The important ones are:

 - `make-or1k-linux` - this is a wrapper for the linux kernel
   build which helps supply the openrisc arches i.e. ARCH and
   CROSS_COMPILE to the kernel build.
 - `qemu-or1k-linux` - this is a qemu wrapper used to start
   a OpenRISC qemu virtual machine running a openrisc linux kernel.
 - `or1ksim-linux` - similar to `qemu-or1k-linux` but starts the
   linux kernel using [or1ksim](https://github.com/openrisc/or1ksim).
 - `qemu-or1k-mkimg` - a tool to build a qemu `qcow2` partitioed disk
   image used for booting openrisc qemu in `qemu-or1k-linux`. 
