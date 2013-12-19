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
PTXDIST		:= /usr/bin/ptxdist-2012.10.0

BUILDDATE	:= $(shell date +%y%m%d-%H%M)
VERSION		:= $(shell ./scripts/setlocalversion ./.tarball-version)

ifeq ($(BENICE),true)
NICE		+= nice -20
endif

ifeq ($(PETALOGIX),true)
# use the Petalogix Microblaze toolchain preperated for ptxdist
TOOLCHAIN_BE	:= /opt/tools-4.1.2-mb-petalogix-v2.1/linux-i386/microblaze-unknown-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.1.2-mb-petalogix-v2.1/linux-i386/microblazeel-unknown-linux-gnu/bin
else
ifeq ($(XILINX),true)
# use the Xilinx Microblaze toolchain preperated for ptxdist
TOOLCHAIN_BE	:= /opt/tools-4.1.2-mb-xilinx-v2.0/microblaze-unknown-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.1.2-mb-xilinx-v2.0/microblazeel-unknown-linux-gnu/bin
else
# use the Crosstool-NG Microblaze toolchain preperated for ptxdist
TOOLCHAIN_BE	:= /opt/tools-4.8.1-mb-ctng-v2.4/microblaze-xilinx-linux-gnu/bin
TOOLCHAIN_LE	:= /opt/tools-4.8.1-mb-ctng-v2.4/microblazeel-xilinx-linux-gnu/bin
endif
endif

CONFIGDIR	:= configs
CONFIGFILE	:= $(CONFIGDIR)/ptxconfig
COLLECFILE	:= $(CONFIGDIR)/startup.collection
PLATFORMFILES	:= $(wildcard $(CONFIGDIR)/*/platformconfig)
PLATFORMS	:= $(notdir $(patsubst %/,%,$(dir $(PLATFORMFILES))))
PLATFORMS_	:= $(subst _,-,$(PLATFORMS))

define gen_2platformfile
$(eval 2PLATFORMFILE_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := $(1))
endef

define gen_2platformname
$(eval 2PLATFORMNAME_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_PLATFORM}"))
endef

define gen_2platformvers
$(eval 2PLATFORMVERS_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_PLATFORM_VERSION}"))
endef

define gen_2platformdir
$(eval 2PLATFORMDIR_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "platform-$${PTXCONF_PLATFORM}"))
endef

define gen_2imgdir
$(eval 2IMAGEDIR_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "platform-$${PTXCONF_PLATFORM}/images"))
endef

define gen_2toolchain
$(eval 2TOOLCHAIN_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(if $(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_ENDIAN_LITTLE}"), \
		$(TOOLCHAIN_LE), \
	$(if $(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_ENDIAN_BIG}"), \
		$(TOOLCHAIN_BE), \
	$(error "$(1): can not determine endianess (big or little)"))))
endef

define gen_2toolchainname
$(eval 2TOOLCHAINNAME_$(subst _,-,$(notdir $(patsubst %/,%,$(dir $(1))))) := \
	$(if $(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_ENDIAN_LITTLE}"), \
		$(shell awk -F'[=]' '{gsub(/\"/,""); printf("%s -- little endian", $$(NF))}' $(TOOLCHAIN_LE)/ptxconfig), \
	$(if $(shell PTX_AUTOBUILD_DESTDIR='' source "$(1)" && echo "$${PTXCONF_ENDIAN_BIG}"), \
		$(shell awk -F'[=]' '{gsub(/\"/,""); printf("%s -- big endian", $$(NF))}' $(TOOLCHAIN_BE)/ptxconfig), \
	$(error "$(1): can not determine endianess (big or little)"))))
endef

$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformfile,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformname,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformvers,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2platformdir,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2imgdir,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2toolchain,$(pltfile)))
$(foreach pltfile,$(PLATFORMFILES),$(call gen_2toolchainname,$(pltfile)))

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

# generic big endian systems
$(STATEDIR)/%.build: $(TOOLCHAIN_BE)/ptxconfig $(TOOLCHAIN_LE)/ptxconfig | mkdirs
	@echo "******************************************************************************"
	@echo "building:  $(2PLATFORMNAME_$(*))"
	@echo " version:  $(2PLATFORMVERS_$(*))"
	@echo "    with:  $(2TOOLCHAINNAME_$(*))"
	@echo "******************************************************************************"
	@echo
	$(NICE) $(PTXDIST) images --ptxconfig=$(CONFIGFILE) \
	  --collectionconfig=$(COLLECFILE) \
	  --toolchain=$(2TOOLCHAIN_$(*)) \
	  --platformconfig=$(2PLATFORMFILE_$(*))

mkdirs:
	@mkdir -p $(STATEDIR) $(DISTDIR)

print-%:
	@echo "$* is \"$($(*))\""

help: print-VERSION print-BUILDDATE print-PTXDIST print-TOOLCHAIN_BE print-TOOLCHAIN_LE
	@echo "Available tarball targets:"
	@for i in $(TBZ2S); do echo $$i; done;
