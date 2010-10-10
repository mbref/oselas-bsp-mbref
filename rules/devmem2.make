# -*-makefile-*-
#
# Copyright (C) 2010 by Stephan Linz <linz@li-pro.net>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DEVMEM2) += devmem2

#
# Paths and names
#
DEVMEM2_VERSION	:= trunk
DEVMEM2		:= devmem2-$(DEVMEM2_VERSION)
DEVMEM2_SUFFIX	:= tar.bz2
DEVMEM2_SRCDIR	:= $(PTXDIST_WORKSPACE)/local_src/$(DEVMEM2)
#DEVMEM2_SRCDIR	:= $(BUILDDIR)/$(DEVMEM2)
#DEVMEM2_URL	:= file://$(PTXDIST_WORKSPACE)/local_src/$(DEVMEM2).$(DEVMEM2_SUFFIX)
DEVMEM2_DIR	:= $(BUILDDIR)/$(DEVMEM2)
DEVMEM2_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.get:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.extract:
	@$(call targetinfo)
	@$(call clean, $(DEVMEM2_DIR))
	@mkdir -p $(DEVMEM2_DIR)
#	@$(call extract, DEVMEM2)
	@$(call patchin, DEVMEM2)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

DEVMEM2_PATH	:= PATH=$(CROSS_PATH)
DEVMEM2_ENV 	:= $(CROSS_ENV)

$(STATEDIR)/devmem2.prepare:
	@$(call targetinfo)
	cp -a $(DEVMEM2_SRCDIR)/* $(DEVMEM2_DIR)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.compile:
	@$(call targetinfo)
	cd $(DEVMEM2_DIR) && \
		$(DEVMEM2_ENV) $(DEVMEM2_PATH) $(MAKE) #$(PARALLELMFLAGS)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.install:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  devmem2)
	@$(call install_fixup, devmem2,PACKAGE,devmem2)
	@$(call install_fixup, devmem2,PRIORITY,optional)
	@$(call install_fixup, devmem2,VERSION,0)
	@$(call install_fixup, devmem2,SECTION,base)
	@$(call install_fixup, devmem2,AUTHOR,"Stephan Linz <linz\@li-pro.net>")
	@$(call install_fixup, devmem2,DEPENDS,)
	@$(call install_fixup, devmem2,DESCRIPTION,missing)

#
# TODO: Add here all files that should be copied to the target
# Note: Add everything before(!) call to macro install_finish
#
	@$(call install_copy, devmem2, 0, 0, 0755, $(DEVMEM2_DIR)/devmem2, /sbin/devmem2)
#	@$(call install_copy, devmem2, 0, 0, 0755, $(DEVMEM2_DIR)/foobar, /dev/null)

	@$(call install_finish, devmem2)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/devmem2.clean:
	@$(call targetinfo)
	@-cd $(DEVMEM2_DIR) && \
		$(DEVMEM2_ENV) $(DEVMEM2_PATH) $(MAKE) clean
	@$(call clean_pkg, DEVMEM2)

# vim: syntax=make
