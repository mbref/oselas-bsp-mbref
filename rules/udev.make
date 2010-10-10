# -*-makefile-*-
#
# Copyright (C) 2005-2008 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_UDEV) += udev

#
# Paths and names
#
UDEV_VERSION	:= 136
UDEV		:= udev-$(UDEV_VERSION)
UDEV_SUFFIX	:= tar.bz2
UDEV_SOURCE	:= $(SRCDIR)/$(UDEV).$(UDEV_SUFFIX)
UDEV_DIR	:= $(BUILDDIR)/$(UDEV)
UDEV_DEVPKG	:= NO

UDEV_URL := \
	http://www.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX) \
	http://www.eu.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX) \
	http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV).$(UDEV_SUFFIX)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(UDEV_SOURCE):
	@$(call targetinfo)
	@$(call get, UDEV)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
UDEV_AUTOCONF := \
	$(CROSS_AUTOCONF_ROOT) \
	--libexecdir=/lib/udev \
	\
	--disable-dependency-tracking \
	--enable-shared

ifdef PTXCONF_UDEV_DEBUG
UDEV_AUTOCONF	+= --enable-debug
else
UDEV_AUTOCONF	+= --disable-debug
endif

ifdef PTXCONF_UDEV_LIBGUDEV
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_LIBGUDEV)
endif

ifdef PTXCONF_UDEV_DEFAULT_KEYMAPS
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_DEFAULT_KEYMAPS)
endif

ifeq ($(PTXCONF_ARCH_ARM)-$(PTXCONF_UDEV_EXTRA_HID2HCI),-y)
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_HID2HCI)
endif

ifdef PTXCONF_UDEV_EXTRA_KEYMAP
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_KEYMAP)
endif

ifdef PTXCONF_UDEV_EXTRA_UDEV_ACL
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_UDEV_ACL)
endif

ifdef PTXCONF_UDEV_EXTRA_USB_DB
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_USB_DB)
endif

ifdef PTXCONF_UDEV_EXTRA_PCI_DB
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_PCI_DB)
endif

ifdef PTXCONF_UDEV_EXTRA_INPUT_ID
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_INPUT_ID)
endif

ifdef PTXCONF_UDEV_EXTRA_MODEM_MODESWITCH
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_MODEM_MODESWITCH)
endif

ifdef PTXCONF_UDEV_EXTRA_FINDKEYBOARDS
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_FINDKEYBOARDS)
endif

ifdef PTXCONF_UDEV_EXTRA_KEYBOARD_FORCE_RELEASE
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_KEYBOARD_FORCE_RELEASE)
endif

ifdef PTXCONF_UDEV_EXTRA_V4L_ID
$(error $(UDEV): unsupported feature, please disable: PTXCONF_UDEV_EXTRA_V4L_ID)
endif

ifdef PTXCONF_UDEV_SELINUX
UDEV_AUTOCONF	+= --with-selinux
else
UDEV_AUTOCONF	+= --without-selinux
endif

ifdef PTXCONF_UDEV_SYSLOG
UDEV_AUTOCONF	+= --enable-logging
else
UDEV_AUTOCONF	+= --disable-logging
endif

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/udev.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  udev)
	@$(call install_fixup, udev,PACKAGE,udev)
	@$(call install_fixup, udev,PRIORITY,optional)
	@$(call install_fixup, udev,VERSION,$(UDEV_VERSION))
	@$(call install_fixup, udev,SECTION,base)
	@$(call install_fixup, udev,AUTHOR,"Robert Schwebel <r.schwebel@pengutronix.de>")
	@$(call install_fixup, udev,DEPENDS,)
	@$(call install_fixup, udev,DESCRIPTION,missing)

#	#
#	# binaries
#	#

	@$(call install_copy, udev, 0, 0, 0755, -, /sbin/udevd)
	@$(call install_copy, udev, 0, 0, 0755, -, /sbin/udevadm)

#	#
#	# default rules
#	#

# install everything apart of drivers rule.
ifdef PTXCONF_UDEV_DEFAULT_RULES
	@cd $(UDEV_DIR)/rules/rules.d; \
	for file in `find . -type f ! -name "*drivers*"`; do \
		$(call install_copy, udev, 0, 0, 0644, \
			$(UDEV_DIR)/rules/rules.d/$$file, \
			/lib/udev/rules.d/$$file, n); \
	done
endif

# install drivers rules.
ifdef PTXCONF_UDEV_DEFAULT_DRIVERS_RULES
	@cd $(UDEV_DIR)/rules/rules.d; \
	for file in `find . -type f -name "*drivers*"`; do \
		$(call install_copy, udev, 0, 0, 0644, \
			$(UDEV_DIR)/rules/rules.d/$$file, \
			/lib/udev/rules.d/$$file, n); \
	done
endif

ifdef PTXCONF_UDEV_COMMON_RULES
#
# these rules are not installed by default
#
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-alsa.rules, \
		/lib/udev/rules.d/40-alsa.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-isdn.rules, \
		/lib/udev/rules.d/40-isdn.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-zaptel.rules, \
		/lib/udev/rules.d/40-zaptel.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-s390.rules, \
		/lib/udev/rules.d/40-s390.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-pilot-links.rules, \
		/lib/udev/rules.d/40-pilot-links.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-ppc.rules, \
		/lib/udev/rules.d/40-ppc.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-infiniband.rules, \
		/lib/udev/rules.d/40-infiniband.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/40-ia64.rules, \
		/lib/udev/rules.d/40-ia64.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/64-device-mapper.rules, \
		/lib/udev/rules.d/64-device-mapper.rules, n);
	@$(call install_copy, udev, 0, 0, 0644, \
		$(UDEV_DIR)/rules/packages/64-md-raid.rules, \
		/lib/udev/rules.d/64-md-raid.rules, n);
endif

ifdef PTXCONF_UDEV_CUST_RULES
	@if [ -d $(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/ ]; then \
		cd $(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/; \
		for file in `find . -type f`; do \
			$(call install_copy, udev, 0, 0, 0644, \
				$(PTXDIST_WORKSPACE)/projectroot/lib/udev/rules.d/$$file, \
				/lib/udev/rules.d/$$file, n); \
		done; \
	else \
		echo "UDEV_CUST_RULES is enabled but Directory containing" \
			"customized udev rules is missing!"; \
		exit 1; \
	fi
endif

#	#
#	# startup script
#	#
ifdef PTXCONF_UDEV_STARTSCRIPT
ifdef PTXCONF_INITMETHOD_BBINIT
	@$(call install_alternative, udev, 0, 0, 0755, /etc/init.d/udev)
ifneq ($(call remove_quotes,$(PTXCONF_UDEV_BBINIT_LINK)),)
	@$(call install_link, udev, \
		../init.d/udev, \
		/etc/rc.d/$(PTXCONF_UDEV_BBINIT_LINK))
endif
endif
ifdef PTXCONF_INITMETHOD_UPSTART
	@$(call install_alternative, udev, 0, 0, 0644, /etc/init/udev.conf)
	@$(call install_alternative, udev, 0, 0, 0644, /etc/init/udevmonitor.conf)
	@$(call install_alternative, udev, 0, 0, 0644, /etc/init/udevtrigger.conf)
	@$(call install_alternative, udev, 0, 0, 0644, /etc/init/udev-finish.conf)
endif
endif


#	#
#	# Install a configuration on demand only
#	#
ifdef PTXCONF_UDEV_ETC_CONF
	@$(call install_alternative, udev, 0, 0, 0644, /etc/udev/udev.conf)
endif

#	#
#	# utilities from extra/
#	#
ifdef PTXCONF_UDEV_EXTRA_ATA_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/ata_id)
endif

ifdef PTXCONF_UDEV_EXTRA_CDROM_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/cdrom_id)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/60-cdrom_id.rules,n)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/75-cd-aliases-generator.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_COLLECT
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/collect)
endif

ifdef PTXCONF_UDEV_EXTRA_EDD_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/edd_id)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/61-persistent-storage-edd.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_FIRMWARE
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/firmware.sh, n)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/50-firmware.rules,n)
endif

ifdef PTXCONF_UDEV_EXTRA_FLOPPY
	@$(call install_copy, udev, 0, 0, 0755, -, \
		/lib/udev/create_floppy_devices)
endif

ifdef PTXCONF_UDEV_EXTRA_FSTAB_IMPORT
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/fstab_import)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/79-fstab_import.rules)
endif

ifdef PTXCONF_UDEV_EXTRA_PATH_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/path_id)
endif

ifdef PTXCONF_UDEV_EXTRA_RULE_GENERATOR
	@$(call install_copy, udev, 0, 0, 0755, -, \
		/lib/udev/rule_generator.functions)
endif

ifdef PTXCONF_UDEV_EXTRA_SCSI_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/scsi_id)
endif

ifdef PTXCONF_UDEV_EXTRA_USB_ID
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/usb_id)
endif

ifdef PTXCONF_UDEV_EXTRA_WRITE_CD_RULES
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/write_cd_rules, n)
endif

ifdef PTXCONF_UDEV_EXTRA_WRITE_NET_RULES
	@$(call install_copy, udev, 0, 0, 0755, -, /lib/udev/write_net_rules, n)
	@$(call install_copy, udev, 0, 0, 0644, -, \
		/lib/udev/rules.d/75-persistent-net-generator.rules,n)
endif

ifdef PTXCONF_UDEV_LIBUDEV
	@$(call install_copy, udev, 0, 0, 0644, -, /lib/libudev.so.0.0.7)
	@$(call install_link, udev, libudev.so.0.0.7, /lib/libudev.so.0)
	@$(call install_link, udev, libudev.so.0.0.7, /lib/libudev.so)
endif

	@$(call install_finish, udev)

	@$(call touch)

# vim: syntax=make
