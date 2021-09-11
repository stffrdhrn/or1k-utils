#!/bin/bash
# Builds the litex dts file, targets:
#  all (default): build the .dtb file
#  clean        : removes everything

LITEX_HOME := $(HOME)/work/litex
JSON2DTS   := $(LITEX_HOME)/litex/litex/tools/litex_json2dts.py

initrd_start_hex = $(shell grep rootfs.cpio.gz boot.json | grep -o "0x[0-9]\+")
initrd_start = $(shell printf "%d" $(initrd_start_hex))
initrd_size  = $(shell stat --format=%s rootfs.cpio.gz)

.PHONY: all clean

all: litex-mor1kx.dtb

clean:
	rm -f litex-mor1kx.dts litex-mor1kx.dtb

litex-mor1kx.dtb: litex-mor1kx.dts
	dtc $< > $@

litex-mor1kx.dts: litex-mor1kx-csr.json boot.json rootfs.cpio.gz
	$(JSON2DTS) --initrd-start $(initrd_start) --initrd-size $(initrd_size) $< > $@

