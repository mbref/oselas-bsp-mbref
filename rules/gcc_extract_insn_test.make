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
PACKAGES-$(PTXCONF_GCC_EXTRACT_INSN_TEST) += gcc_extract_insn_test

#
# Paths and names
#
ifdef PTXCONF_GCC_EXTRACT_INSN_TEST_TRUNK
GCC_EXTRACT_INSN_TEST_VERSION	:= trunk
else
GCC_EXTRACT_INSN_TEST_VERSION	:= trunk
GCC_EXTRACT_INSN_TEST_MD5	:=
endif
GCC_EXTRACT_INSN_TEST		:= gcc_extract_insn_test-$(GCC_EXTRACT_INSN_TEST_VERSION)
GCC_EXTRACT_INSN_TEST_URL	:= file://$(PTXDIST_WORKSPACE)/local_src/$(GCC_EXTRACT_INSN_TEST)
GCC_EXTRACT_INSN_TEST_DIR	:= $(BUILDDIR)/$(GCC_EXTRACT_INSN_TEST)
GCC_EXTRACT_INSN_TEST_BUILD_OOT	:= YES
GCC_EXTRACT_INSN_TEST_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ifdef PTXCONF_GCC_EXTRACT_INSN_TEST_TRUNK
$(STATEDIR)/gcc_extract_insn_test.extract: $(STATEDIR)/autogen-tools
endif

$(STATEDIR)/gcc_extract_insn_test.extract:
	@$(call targetinfo)
	@$(call clean, $(GCC_EXTRACT_INSN_TEST_DIR))
	@$(call extract, GCC_EXTRACT_INSN_TEST)
ifdef PTXCONF_GCC_EXTRACT_INSN_TEST_TRUNK
	cd $(GCC_EXTRACT_INSN_TEST_DIR) && sh autogen.sh
else
	cd $(GCC_EXTRACT_INSN_TEST_DIR) && [ -f configure ] || sh autogen.sh
endif
	@$(call patchin, GCC_EXTRACT_INSN_TEST)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#GCC_EXTRACT_INSN_TEST_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
GCC_EXTRACT_INSN_TEST_CONF_TOOL	:= autoconf
GCC_EXTRACT_INSN_TEST_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

ifdef PTXCONF_GCC_EXTRACT_INSN_TEST_FORCE_ERROR
GCC_EXTRACT_INSN_TEST_CONF_OPT	+= --enable-gccerror
endif

#$(STATEDIR)/gcc_extract_insn_test.prepare:
#	@$(call targetinfo)
#	@$(call world/prepare, GCC_EXTRACT_INSN_TEST)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/gcc_extract_insn_test.compile:
#	@$(call targetinfo)
#	@$(call world/compile, GCC_EXTRACT_INSN_TEST)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/gcc_extract_insn_test.install:
#	@$(call targetinfo)
#	@$(call world/install, GCC_EXTRACT_INSN_TEST)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/gcc_extract_insn_test.targetinstall:
	@$(call targetinfo)

	@$(call install_init, gcc_extract_insn_test)
	@$(call install_fixup, gcc_extract_insn_test, PRIORITY, optional)
	@$(call install_fixup, gcc_extract_insn_test, SECTION, base)
	@$(call install_fixup, gcc_extract_insn_test, AUTHOR, "Stephan Linz <linz@li-pro.net>")
	@$(call install_fixup, gcc_extract_insn_test, DESCRIPTION, missing)

#	#
#	# example code:; copy all libraries, links and binaries
#	#

#	@for i in $(shell cd $(GCC_EXTRACT_INSN_TEST_PKGDIR) && find bin sbin usr/bin usr/sbin -type f); do \
#		$(call install_copy, gcc_extract_insn_test, 0, 0, 0755, -, /$$i); \
#	done
#	@for i in $(shell cd $(GCC_EXTRACT_INSN_TEST_PKGDIR) && find lib usr/lib -name "*.so*"); do \
#		$(call install_copy, gcc_extract_insn_test, 0, 0, 0644, -, /$$i); \
#	done
#	@links="$(shell cd $(GCC_EXTRACT_INSN_TEST_PKGDIR) && find lib usr/lib -type l)"; \
#	if [ -n "$$links" ]; then \
#		for i in $$links; do \
#			from="`readlink $(GCC_EXTRACT_INSN_TEST_PKGDIR)/$$i`"; \
#			to="/$$i"; \
#			$(call install_link, gcc_extract_insn_test, $$from, $$to); \
#		done; \
#	fi

#	#
#	# FIXME: add all necessary things here
#	#

	@$(call install_finish, gcc_extract_insn_test)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/gcc_extract_insn_test.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, GCC_EXTRACT_INSN_TEST)

# vim: syntax=make
