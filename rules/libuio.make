# -*-makefile-*-
#
# Copyright (C) 2011 by Stephan Linz
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBUIO) += libuio

#
# Paths and names
#
LIBUIO_VERSION	:= 0.2.1
LIBUIO_MD5	:= 0d798c4fd8649b3524ab19d2b1151bf7
LIBUIO		:= libuio-$(LIBUIO_VERSION)
LIBUIO_SUFFIX	:= tar.bz2
LIBUIO_URL	:= http://download.sourceforge.net/libuio//$(LIBUIO).$(LIBUIO_SUFFIX)
LIBUIO_SOURCE	:= $(SRCDIR)/$(LIBUIO).$(LIBUIO_SUFFIX)
LIBUIO_DIR	:= $(BUILDDIR)/$(LIBUIO)
LIBUIO_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(LIBUIO_SOURCE):
	@$(call targetinfo)
	@$(call get, LIBUIO)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBUIO_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBUIO_CONF_TOOL	:= autoconf
LIBUIO_CONF_OPT		:= $(CROSS_AUTOCONF_USR)

$(STATEDIR)/libuio.prepare:
	@$(call targetinfo)
	@$(call clean, $(LIBUIO_DIR)/config.cache)
	cd $(LIBUIO_DIR) && \
		$(LIBUIO_PATH) $(LIBUIO_ENV) \
		./configure $(LIBUIO_CONF_OPT)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libuio.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBUIO)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libuio.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBUIO)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libuio.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  libuio)
	@$(call install_fixup, libuio,PRIORITY,optional)
	@$(call install_fixup, libuio,SECTION,base)
	@$(call install_fixup, libuio,AUTHOR,"Stephan Linz <linz@li-pro.net>")
	@$(call install_fixup, libuio,DESCRIPTION,missing)

	@$(call install_copy, libuio, 0, 0, 0755, -, /usr/bin/lsuio)
	@$(call install_copy, libuio, 0, 0, 0755, -, /usr/bin/rwuio)

	@$(call install_copy, libuio, 0, 0, 0644, -, /usr/lib/libuio.so.0.1.0)
	@$(call install_link, libuio, libuio.so.0.1.0, /usr/lib/libuio.so.0)
	@$(call install_link, libuio, libuio.so.0.1.0, /usr/lib/libuio.so)

	@$(call install_finish, libuio)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libuio.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBUIO)

# vim: syntax=make
