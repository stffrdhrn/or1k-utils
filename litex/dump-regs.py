#!/usr/bin/env python3

from litex import RemoteClient

wb = RemoteClient()
wb.open()

# # #

# Access SDRAM
#wb.write(0x40000000, 0x12345678)
#value = wb.read(0x40000000)

# Access SDRAM (with wb.mems and base address)
#wb.write(wb.mems.main_ram.base, 0x12345678)
#value = wb.read(wb.mems.main_ram.base)

# Trigger a reset of the SoC
#wb.regs.ctrl_reset.write(1)

# Dump all CSR registers of the SoC
for name, reg in wb.regs.__dict__.items():
    print("0x{:08x} : 0x{:08x} {}".format(reg.addr, reg.read(), name))

# # #

wb.close()
