# -*-makefile-*-
#
# Copyright (C) 2012 by Bernhard Walle <bernhard@bwalle.de>
#               2013 by Stephan Linz <linz@li-pro.net> (adapt to microblaze)
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_QEMU) += host-qemu

#
# Paths and names
#
HOST_QEMU_VERSION	:= xilinx-v14.6
HOST_QEMU_MD5		:= 028198bbff19337a04bd6f3e25484226
HOST_QEMU		:= qemu-$(HOST_QEMU_VERSION)
HOST_QEMU_SUFFIX	:= tar.bz2
HOST_QEMU_URL		:= http://store.li-pro.net/qemu/$(HOST_QEMU).$(HOST_QEMU_SUFFIX)
HOST_QEMU_SOURCE	:= $(SRCDIR)/$(HOST_QEMU).$(HOST_QEMU_SUFFIX)
HOST_QEMU_DIR		:= $(HOST_BUILDDIR)/$(HOST_QEMU)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_QEMU_CONF_TOOL	:= autoconf
HOST_QEMU_CONF_OPT	:= $(HOST_AUTOCONF) \
	--extra-cflags="$(HOST_CPPFLAGS)" \
	--target-list="microblazeel-softmmu,microblaze-softmmu" \
	--enable-fdt \
	--disable-kvm

# vim: syntax=make
