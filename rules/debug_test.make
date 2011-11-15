# -*-makefile-*-
#
# Copyright (C) 2011 by Stephan Linz <linz@li-pro.net>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_DEBUG_TEST) += debug_test

#
# Paths and names
#
DEBUG_TEST_VERSION	:= trunk
DEBUG_TEST		:= debug_test-$(DEBUG_TEST_VERSION)
DEBUG_TEST_SUFFIX	:= tar.bz2
DEBUG_TEST_SRCDIR	:= $(PTXDIST_WORKSPACE)/local_src/$(DEBUG_TEST)
#DEBUG_TEST_SRCDIR	:= $(BUILDDIR)/$(DEBUG_TEST)
#DEBUG_TEST_URL		:= file://$(PTXDIST_WORKSPACE)/local_src/$(DEBUG_TEST).$(DEBUG_TEST_SUFFIX)
DEBUG_TEST_DIR		:= $(BUILDDIR)/$(DEBUG_TEST)
DEBUG_TEST_LICENSE	:= GPL

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/debug_test.extract:
	@$(call targetinfo)
	@$(call clean, $(DEBUG_TEST_DIR))
	@mkdir -p $(DEBUG_TEST_DIR)
#	@$(call extract, DEBUG_TEST)
	@$(call patchin, DEBUG_TEST)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#DEBUG_TEST_PATH	:= PATH=$(CROSS_PATH)
DEBUG_TEST_CONF_TOOL	:= NO
DEBUG_TEST_MAKE_ENV	:= $(CROSS_ENV)

$(STATEDIR)/debug_test.prepare:
	@$(call targetinfo)
	cp -a $(DEBUG_TEST_SRCDIR)/* $(DEBUG_TEST_DIR)
#	@$(call world/prepare, DEBUG_TEST)
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/debug_test.compile:
#	@$(call targetinfo)
#	@$(call world/compile, DEBUG_TEST)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/debug_test.install:
#	@$(call targetinfo)
#	@$(call world/install, DEBUG_TEST)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/debug_test.targetinstall:
	@$(call targetinfo)

	@$(call install_init, debug_test)
	@$(call install_fixup, debug_test,PRIORITY,optional)
	@$(call install_fixup, debug_test,SECTION,base)
	@$(call install_fixup, debug_test,AUTHOR,"Stephan Linz <linz@li-pro.net>")
	@$(call install_fixup, debug_test,DESCRIPTION,missing)

#
# TODO: Add here all files that should be copied to the target
# Note: Add everything before(!) call to macro install_finish
#
	@$(call install_copy, debug_test, 0, 0, 0755, $(DEBUG_TEST_DIR)/debug_test, /usr/bin/debug_test)

	@$(call install_finish, debug_test)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/debug_test.clean:
	@$(call targetinfo)
	@-cd $(DEBUG_TEST_DIR) && \
		$(DEBUG_TEST_ENV) $(DEBUG_TEST_PATH) $(MAKE) clean
	@$(call clean_pkg, DEBUG_TEST)

# vim: syntax=make
