#!/usr/bin/env python

import sys
import time

from litex import RemoteClient

class BenchController:
    def __init__(self, bus):
        self.bus = bus

    def reboot(self):
       self.bus.regs.ctrl_reset.write(1)

def reboot():

    bus = RemoteClient()
    bus.open()

    # # #

    print("Rebooting SoC...")
    ctrl = BenchController(bus)
    ctrl.reboot()

    # # #

    bus.close()

def main():
    reboot()

if __name__ == "__main__":
    main()
