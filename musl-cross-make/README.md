# Config for musl-cross-make

Put this config or link to this config in the musl-cross-make
home directory.

Run:

```
make -j10
make install
```

The toolchain will be installed to ./output we can package that up
or use it directly.

When building busybox it needs linux headers. These are not provided
by default by the musl toolchain.  To get them I installed them into
the musl toolchain directory.  This worked but maybe is not ideal,
in glibc the headers are installed into a sysroot.

```
# in musl-cross-make
cd linux-headers-xxx
CC=false make ARCH=openrisc INSTALL_HDR_PATH=/home/shorne/work/openrisc/musl-cross-make/output/or1k-smh-linux-musl headers_install
```

We can see the reason for this is because of the include paths incuded by
musl vs glibc which is configured by `--with-sysroot` during gcc compilation.

See below.

```
$ or1k-smh-linux-musl-gcc -xc -E -v -
Using built-in specs.
COLLECT_GCC=or1k-smh-linux-musl-gcc
Target: or1k-smh-linux-musl
Configured with: ../src_gcc/configure --enable-languages=c,c++ CFLAGS='-g -Og' CXXFLAGS='-g -Og' --disable-nls --enable-languages=c,c++ --disable-libssp --with-multilib-list=mcmov --disable-bootstrap --disable-assembly --disable-werror --target=or1k-smh-linux-musl --prefix= --libdir=/lib --disable-multilib --with-sysroot=/or1k-smh-linux-musl --enable-tls --disable-libmudflap --disable-libsanitizer --disable-gnu-indirect-function --disable-libmpx --enable-initfini-array --enable-libstdcxx-time=rt --with-build-sysroot=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_sysroot AR_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/ar AS_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/gas/as-new LD_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/ld/ld-new NM_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/nm-new OBJCOPY_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/objcopy OBJDUMP_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/objdump RANLIB_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/ranlib READELF_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/readelf STRIP_FOR_TARGET=/home/shorne/work/openrisc/musl-cross-make/build/local/or1k-smh-linux-musl/obj_binutils/binutils/strip-new --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 11.2.0 (GCC) 
COLLECT_GCC_OPTIONS='-E' '-v'
 /home/shorne/work/openrisc/musl-cross-make/output/bin/../libexec/gcc/or1k-smh-linux-musl/11.2.0/cc1 -E -quiet -v -iprefix /home/shorne/work/openrisc/musl-cross-make/output/bin/../lib/gcc/or1k-smh-linux-musl/11.2.0/ -isysroot /home/shorne/work/openrisc/musl-cross-make/output/bin/../or1k-smh-linux-musl - -dumpbase -
ignoring nonexistent directory "/home/shorne/work/openrisc/musl-cross-make/output/bin/../or1k-smh-linux-musl/usr/local/include"
ignoring duplicate directory "/home/shorne/work/openrisc/musl-cross-make/output/bin/../lib/gcc/../../lib/gcc/or1k-smh-linux-musl/11.2.0/../../../../or1k-smh-linux-musl/include"
ignoring nonexistent directory "/home/shorne/work/openrisc/musl-cross-make/output/bin/../or1k-smh-linux-musl/usr/include"
ignoring duplicate directory "/home/shorne/work/openrisc/musl-cross-make/output/bin/../lib/gcc/../../lib/gcc/or1k-smh-linux-musl/11.2.0/include"
#include "..." search starts here:
#include <...> search starts here:
 /home/shorne/work/openrisc/musl-cross-make/output/bin/../lib/gcc/or1k-smh-linux-musl/11.2.0/../../../../or1k-smh-linux-musl/include
 /home/shorne/work/openrisc/musl-cross-make/output/bin/../lib/gcc/or1k-smh-linux-musl/11.2.0/include
End of search list.
```

```
$ or1k-smh-linux-gnu-gcc -xc -E -v -
Using built-in specs.
COLLECT_GCC=/home/shorne/work/gnu-toolchain/local/bin/or1k-smh-linux-gnu-gcc
Target: or1k-smh-linux-gnu
Configured with: /home/shorne/work/gnu-toolchain/gcc/configure --with-gnu-ld --with-gnu-as --disable-nls --disable-libssp --with-multilib-list=mcmov --enable-languages=c,c++ -
-target=or1k-smh-linux-gnu --prefix=/home/shorne/work/gnu-toolchain/local --with-sysroot=/home/shorne/work/gnu-toolchain/sysroot
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 12.0.1 20220210 (experimental) [master revision 32c3a753906:8a9ba017b48:b48d4e6818674898f90d9358378c127511ef0f9f] (GCC) 
COLLECT_GCC_OPTIONS='-E' '-v'
 /home/shorne/work/gnu-toolchain/local/libexec/gcc/or1k-smh-linux-gnu/12.0.1/cc1 -E -quiet -v - -dumpbase -
ignoring nonexistent directory "/home/shorne/work/gnu-toolchain/sysroot/usr/local/include"
#include "..." search starts here:
#include <...> search starts here:
 /home/shorne/work/gnu-toolchain/local/lib/gcc/or1k-smh-linux-gnu/12.0.1/include
 /home/shorne/work/gnu-toolchain/local/lib/gcc/or1k-smh-linux-gnu/12.0.1/include-fixed
 /home/shorne/work/gnu-toolchain/local/lib/gcc/or1k-smh-linux-gnu/12.0.1/../../../../or1k-smh-linux-gnu/include
 /home/shorne/work/gnu-toolchain/sysroot/usr/include
End of search list.
```
