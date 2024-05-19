vi: ft=markdown
---
Keeping my todo list for everything openrisc related.

## TODO

 linux
  - rseq
  - VDSO
  - common-entry framework
  - Virtually mapped stacks
  - Update architecture logging to use pr_* instead of printk
  - eBFD jit support
  - Support for jump_label patching
  - Huge TLB pages with ATB (16mb) - no hardware, probably no need
  - Ftrace and perf support
     * `_mcount`
     * dynamic mcount
     * CONFIG_FUNCTION_GRAPH_TRACER

 KVM/virtio
  - OpenRISC does not support virtualization (only two mode levels)
  - However, we could think of getting qemu x86 KVM working with openrisc
    translation. Not possible: https://stackoverflow.com/questions/69516247/how-to-instantiate-an-arm-based-vm-through-linux-kvm-api-on-x86
  - This needs virtualization extensions(Hypervisor mode) added to OpenRISC

 gcc PRs
  - https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102584 - unsigned short
  - https://gcc.gnu.org/bugzilla/show_bug.cgi?id=28036  - exec stack no note

## DONE

Items done moved down here!

### Done 2024-05-19

Linux v6.10 upstreamed
  - Better FPU handling (patches on branch)

Glibc FPU support upstream.

### Done 2024-03-30

These items were done a while back but moved to done now.

linux next 5.18
  - gcc machine instructions  (don't remember what this even was)

 Glibc Test Results 2.35 - Upstreamed

 qeme patches (dts, initrd) get upstream

 marocchino upstream
 docs
 - fpcsr - is now writable in user mode!


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

