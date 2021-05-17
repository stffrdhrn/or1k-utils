#!/usr/bin/env python

import sys
import time

from litex import RemoteClient
from litex.soc.integration.common import get_mem_data

class BenchController:
    def __init__(self, bus):
        self.bus = bus

    def dump_mem(self, addr_str, length_str):
        offset = 0
        addr = int(addr_str, 16)
        length = int(length_str)
        for read_addr in range(addr, addr+length, 4):
            read_data = self.bus.read(read_addr)
            if (read_addr % 16 == 0):
              print("")
              print("{:08x}: {:08x}".format(read_addr, read_data), end='')
            else:
              print(" {:08x}".format(read_data), end='')
        print("")

def dump_mem(addr_str, length_str):

    bus = RemoteClient()
    bus.open()

    # # #

    # Load BIOS and reboot SoC.
    print("Reading memory...")
    ctrl = BenchController(bus)
    ctrl.dump_mem(addr_str, length_str)

    # # #

    bus.close()

def main():
    dump_mem(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    main()
