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
PACKAGES-$(PTXCONF_IWATCHER) += iwatcher

#
# Paths and names
#
ifdef PTXCONF_IWATCHER_TRUNK
IWATCHER_VERSION	:= trunk
else
IWATCHER_VERSION	:= trunk
IWATCHER_MD5		:=
endif
IWATCHER		:= iwatcher-$(IWATCHER_VERSION)
IWATCHER_URL		:= file://$(PTXDIST_WORKSPACE)/local_src/$(IWATCHER)
IWATCHER_DIR		:= $(BUILDDIR)/$(IWATCHER)
IWATCHER_BUILD_OOT	:= YES
IWATCHER_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ifdef PTXCONF_IWATCHER_TRUNK
$(STATEDIR)/iwatcher.extract: $(STATEDIR)/autogen-tools
endif

$(STATEDIR)/iwatcher.extract:
	@$(call targetinfo)
	@$(call clean, $(IWATCHER_DIR))
	@$(call extract, IWATCHER)
ifdef PTXCONF_IWATCHER_TRUNK
	cd $(IWATCHER_DIR) && sh autogen.sh
else
	cd $(IWATCHER_DIR) && [ -f configure ] || sh autogen.sh
endif
	@$(call patchin, IWATCHER)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#IWATCHER_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
IWATCHER_CONF_TOOL	:= autoconf
#IWATCHER_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/iwatcher.prepare:
#	@$(call targetinfo)
#	@$(call world/prepare, IWATCHER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/iwatcher.compile:
#	@$(call targetinfo)
#	@$(call world/compile, IWATCHER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/iwatcher.install:
#	@$(call targetinfo)
#	@$(call world/install, IWATCHER)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/iwatcher.targetinstall:
	@$(call targetinfo)

	@$(call install_init, iwatcher)
	@$(call install_fixup, iwatcher, PRIORITY, optional)
	@$(call install_fixup, iwatcher, SECTION, base)
	@$(call install_fixup, iwatcher, AUTHOR, "Stephan Linz <linz@li-pro.net>")
	@$(call install_fixup, iwatcher, DESCRIPTION, missing)

#	#
#	# example code:; copy all libraries, links and binaries
#	#

	@for i in $(shell cd $(IWATCHER_PKGDIR) && find bin sbin usr/bin usr/sbin -type f); do \
		$(call install_copy, iwatcher, 0, 0, 0755, -, /$$i); \
	done
	@for i in $(shell cd $(IWATCHER_PKGDIR) && find lib usr/lib -name "*.so*"); do \
		$(call install_copy, iwatcher, 0, 0, 0644, -, /$$i); \
	done
	@links="$(shell cd $(IWATCHER_PKGDIR) && find lib usr/lib -type l)"; \
	if [ -n "$$links" ]; then \
		for i in $$links; do \
			from="`readlink $(IWATCHER_PKGDIR)/$$i`"; \
			to="/$$i"; \
			$(call install_link, iwatcher, $$from, $$to); \
		done; \
	fi

#	#
#	# FIXME: add all necessary things here
#	#

	@$(call install_finish, iwatcher)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/iwatcher.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, IWATCHER)

# vim: syntax=make
