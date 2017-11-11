
# Connect
Telnet to OpenOCD

 telnet localhost 4444

## Load a newly built kernel

 halt; load_image ../linux/vmlinux ; reg npc 0x100; reg r3 0x0; resume

## Known good kernel

 halt; load_image vmlinux-shorne ; reg npc 0x100; reg r3 0x0; resume

# How it works
## Initialize the init script

 init

## requesting target halt and executing a soft reset
# Halt the cpu

 halt

## Load an image (the image location is relative to the working directory of openocd)

 load_image tutorials/de0_nano/hello.elf

## Perform a reset (this is used to start cpus)

 reset

# Set a register (in this case next program counter)
# OpenRISC reset vector is 0x100 so this causes the cpu to jump
# to the start of our program which should start at 0x100

 reg npc 0x100

# Resume execution after a halt

 resume

## In GDB

Getting into tui mode

 layout split
 focus cmd

Dispaying memory

 p      *mem_map # show symbol value
 x/10ih 0x100    # disasm 10 instructions starting at 0x100

## SMP

fusesoc pgm de0_nano-multicore

# De0 nano is setup with
# set TAP_TYPE VJTAG_SMP
# to enable SMP (2 cpus) for virtual jtag device
# requires my openocd patches
openocd -f ./or1k-utils/openocd/de0_nano.cfg

# GDB with gdbinit in your homedir (from or1k-utils)
or1k-elf-gdb --eval-command 'target remote localhost:3333' vmlinux

```
(gdb) load_reset
(gdb) load
(gdb) reset
```
