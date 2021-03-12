#!/usr/bin/env python

import sys
import time

from litex import RemoteClient
from litex.soc.integration.common import get_mem_data

class BenchController:
    def __init__(self, bus):
        self.bus = bus

    def reboot(self):
       self.bus.regs.ctrl_reset.write(1)

    def load_rom(self, filename, delay=0):
        rom_data = get_mem_data(filename, "big")
        for i, data in enumerate(rom_data):
            self.bus.write(self.bus.mems.rom.base + 4*i, data)
            print(f"{(i+1)*4}/{len(rom_data*4)} bytes\r", end="")
            time.sleep(delay)
        print("")

def load_bios(bios_filename):

    bus = RemoteClient()
    bus.open()

    # # #

    # Load BIOS and reboot SoC.
    print("Loading BIOS...")
    ctrl = BenchController(bus)
    ctrl.load_rom(bios_filename, delay=1e-4) # FIXME: delay needed @ 115200bauds.
    ctrl.reboot()

    # # #

    bus.close()

def main():
    load_bios(sys.argv[1])

if __name__ == "__main__":
    main()
