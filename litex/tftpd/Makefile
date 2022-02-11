#!/bin/bash
# Builds the litex dts file, targets:
#  all (default): build the .dtb file
#  clean        : removes everything

LITEX_HOME := $(HOME)/work/litex
JSON2DTS   := $(LITEX_HOME)/litex/litex/tools/litex_json2dts_linux.py
# ROOTFS set disabled to disable intrd, set to something like
#        rootfs.cpio.gz.  To have the generator calculate the size.
ROOTFS     := disabled

ifeq (disabled,$(ROOTFS))
rootfs_file := dummy-rootfs.cpio.gz
else
rootfs_file := $(ROOTFS)
endif

kernel_size := $(shell stat --format="%s" boot.bin)
rootfs_size := $(shell stat --format="%s" $(rootfs_file))
# Round up a few bytes
kernel_size := $(shell echo "$$(( ( $(kernel_size) + 15 ) & 0xfffffff0))" )
rootfs_size := $(shell echo "$$(( ( $(rootfs_size) + 15 ) & 0xfffffff0))" )

# Recursive var used for boot.json, remember expanded when used
dtb_offset   = $(shell expr $(kernel_size) + $(rootfs_size))

# Leave blank to boot from ram
root_device = --root-device mmcblk0p3

.PHONY: all clean

all: boot.json

clean:
	rm -f boot.json litex-mor1kx.dts litex-mor1kx.dtb

boot.json: boot.json.tmpl litex-mor1kx.dtb boot.bin $(rootfs_file)
	sed -e 's/__rootfs_offset__/$(shell printf "0x%08x" $(kernel_size))/' \
		-e 's/__rootfs__/$(rootfs_file)/' \
		-e 's/__dtb_offset__/$(shell printf "0x%08x" $(dtb_offset))/' \
		boot.json.tmpl > $@

litex-mor1kx.dtb: litex-mor1kx.dts
	dtc $< > $@

litex-mor1kx.dts: litex-mor1kx-csr.json $(roofs_file) $(JSON2DTS)
	$(JSON2DTS) --initrd-start $(kernel_size) --initrd $(ROOTFS) $(root_device) $< > $@

