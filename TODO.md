vi: ft=markdown
---
Keeping my todo list for everything openrisc related.

## TODO

 linux next 5.18
 - rseq
 - gcc machine instructions

 Glibc Test Results 2.35 - running...

 qeme patches (dts, initrd) get upstream

 marocchino upstream
 docs
 - fpcsr

 gcc PRs
  - https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102584 - unsigned short
  - https://gcc.gnu.org/bugzilla/show_bug.cgi?id=28036  - exec stack no note

## DONE

Items done moved down here!

### Done 2022-02-11

 qemu patches - sent v1, v2
 - dts
 - initrd
   Review
    - single definition for OR1KSIM_CLK_MHZ 20000000
    - split to
      mmap
      dts
      initrd

### Done 2022-02-08

 Glibc
 - Fix build failure: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=104153

### Done 2022-02-05

 linux next 5.18
  - `mm: mmu_gathers` - patch sent 2022-02-05, Acked Mike R
  - `get_fs`          - patch sent 2022-02-06

### Done 2022-02-02
 buildroot upstreaming
  - gcc      - `-D_REENTRANT`
  - binutils - `R_OR1K_GOT16` signed overflow by using special howto
 glibc upstreaming
  - `PI_STATIC_AND_HIDDEN`

### Done 2022-01-30

 Issue [openrisc/or1k_marocchino#23](https://github.com/openrisc/or1k_marocchino/issues/23)

 linux next 5.18
 - kuni-san patches

