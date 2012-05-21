#!/usr/bin/make -f

BENICE		:= false
PETALOGIX	:= false
XILINX		:= false

#
# Makefile to build all platform images, borrowed in parts from the
# OSELAS.Toolchain() script build_all_v2.mk.
#
# Copyright (C) 2007 Carsten Schlote <c.schlote@konzeptpark.de>
#               2008, 2011 Marc Kleine-Budde <mkl@pengutronix.de>
#               2011, 2012 Stephan Linz <linz@li-pro.net>
#

SHELL		:= /bin/bash
PTXDIST		:= /usr/bin/ptxdist-2012.05.0

BUILDDATE	:= $(shell date +%y%m%d-%H%M)
VERSION		:= $(shell ./scripts/setlocalversion ./.tarball-version)

ifeq ($(BENICE),true)
NICE		+= nice -20
endif

ifeq ($(PETALOGIX),true)
# use the Petalogix Microblaze toolchain preperated for ptxdist
TOOLCHAIN	:= /opt/tools-4.1.2-mb-petalogix-v2.1/linux-i386/microblaze-unknown-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.1.2-mb-petalogix-v2.1/linux-i386/microblazeel-unknown-linux-gnu/bin
else
ifeq ($(XILINX),true)
# use the Xilinx Microblaze toolchain preperated for ptxdist
TOOLCHAIN	:= /opt/tools-4.1.2-mb-xilinx-v2.0/microblaze-unknown-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.1.2-mb-xilinx-v2.0/microblazeel-unknown-linux-gnu/bin
else
# use the Crosstool-NG Microblaze toolchain preperated for ptxdist
TOOLCHAIN	:= /opt/tools-4.1.2-mb-ctng-v1.4/microblaze-unknown-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.1.2-mb-ctng-v1.4/microblazeel-unknown-linux-gnu/bin
endif
endif

CONFIGDIR	:= configs
CONFIGFILE	:= $(CONFIGDIR)/ptxconfig
PLATFORMFILES	:= $(wildcard $(CONFIGDIR)/*/platformconfig)
PLATFORMS	:= $(notdir $(patsubst %/,%,$(dir $(PLATFORMFILES))))
PLATFORMS_	:= $(subst _,-,$(PLATFORMS))

define gen_2platformfile
$(eval 2PLATFORMFILE_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := $(1))
endef

define gen_2platformdir
$(eval 2PLATFORMDIR_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "platform-$${PTXCONF_PLATFORM}"))
endef

define gen_2imgdir
$(eval 2IMAGEDIR_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "platform-$${PTXCONF_PLATFORM}/images"))
endef

$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformfile,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformdir,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2imgdir,$(pltfile)))

STATEDIR	:= gstate
DISTDIR		:= dist

PREFIX		:= $(DISTDIR)/oselas-bsp-mbref-$(VERSION)-
PLATFORMS_PREFIX:= $(foreach platform,$(PLATFORMS_),$(addprefix $(PREFIX),$(platform)))

TBZ2_PREFIX	:= $(PREFIX)
TBZ2_SUFFIX	:= -images.tar.bz2

TBZ2S		:= $(foreach platform,$(PLATFORMS_PREFIX),$(addsuffix $(TBZ2_SUFFIX),$(platform)))

all: $(TBZ2S)

$(TBZ2_PREFIX)%$(TBZ2_SUFFIX): $(STATEDIR)/%.build | mkdirs
	@echo 'tar -C "$(2IMAGEDIR_$(*))" -cvjf "$(@)" "."' | fakeroot
	@rm -rf "$(2PLATFORMDIR_$(*))"

# special AXI little endian systems
$(STATEDIR)/Avnet-S6LX150T-AXI-%.build: $(TOOLCHAIN_LE)/ptxconfig | mkdirs
	@echo "found AXI little endian system"
	@echo "building Avnet-S6LX150T-AXI-${*} with" $(shell awk -F'[=]' '{printf("%s", $$(NF))}' $<)
	$(NICE) $(PTXDIST) images --ptxconfig=$(CONFIGFILE) \
	  --toolchain=$(TOOLCHAIN_LE) --platformconfig=$(2PLATFORMFILE_Avnet-S6LX150T-AXI-$(*))

$(STATEDIR)/Xilinx-ML605-AXI-%.build: $(TOOLCHAIN_LE)/ptxconfig | mkdirs
	@echo "found AXI little endian system"
	@echo "building Xilinx-ML605-AXI-${*} with" $(shell awk -F'[=]' '{printf("%s", $$(NF))}' $<)
	$(NICE) $(PTXDIST) images --ptxconfig=$(CONFIGFILE) \
	  --toolchain=$(TOOLCHAIN_LE) --platformconfig=$(2PLATFORMFILE_Xilinx-ML605-AXI-$(*))

# generic big endian systems
$(STATEDIR)/%.build: $(TOOLCHAIN)/ptxconfig | mkdirs
	@echo "building ${*} with" $(shell awk -F'[=]' '{printf("%s", $$(NF))}' $<)
	$(NICE) $(PTXDIST) images --ptxconfig=$(CONFIGFILE) \
	  --toolchain=$(TOOLCHAIN) --platformconfig=$(2PLATFORMFILE_$(*))

mkdirs:
	@mkdir -p $(STATEDIR) $(DISTDIR)

print-%:
	@echo "$* is \"$($(*))\""

help: print-VERSION print-BUILDDATE print-PTXDIST print-TOOLCHAIN print-TOOLCHAIN_LE
	@echo "Available tarball targets:"
	@for i in $(TBZ2S); do echo $$i; done;
